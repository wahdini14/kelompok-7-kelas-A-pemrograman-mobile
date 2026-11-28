import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/validators.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

/// Pesan error yang aman ditampilkan langsung ke pengguna.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Semua urusan login, registrasi, dan data akun ada di sini.
/// Dipakai oleh halaman Pencari Kerja maupun Pemberi Kerja.
class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const String _wrongCredentials =
      'Email/nomor HP atau kata sandi salah.';

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _lookup =>
      _db.collection('login_lookup');

  /// Pengguna yang sedang login (null jika belum login).
  User? get currentUser => _auth.currentUser;

  /// Memberi kabar setiap kali status login berubah.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Membaca data akun dari Firestore.
  Future<UserModel?> getProfile(String uid) async {
    final snap = await _users.doc(uid).get();
    final data = snap.data();
    if (data == null) return null;
    return UserModel.fromMap(uid, data);
  }

  /// Membuat akun baru dengan peran tertentu.
  Future<UserModel> register({
    required String fullName,
    required String phoneInput,
    required String emailInput,
    required String password,
    required UserRole role,
  }) async {
    final phone = Validators.normalizePhone(phoneInput);
    if (phone == null) {
      throw const AuthException('Nomor HP tidak valid.');
    }
    final email = emailInput.trim().toLowerCase();
    final authEmail = Validators.phoneToAuthEmail(phone);

    // 1. Pastikan email (jika diisi) belum dipakai akun lain.
    if (email.isNotEmpty) {
      final taken = await _lookup.doc('email_$email').get();
      if (taken.exists) {
        throw const AuthException('Email ini sudah digunakan akun lain.');
      }
    }

    // 2. Buat akun di Firebase Auth. Jika nomor HP sudah terdaftar,
    //    Firebase menolaknya di sini.
    final UserCredential cred;
    try {
      cred = await _auth.createUserWithEmailAndPassword(
        email: authEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
    final user = cred.user!;

    // 3. Simpan profil (termasuk peran) ke Firestore.
    final profile = UserModel(
      uid: user.uid,
      fullName: fullName.trim(),
      phone: phone,
      email: email,
      role: role,
    );

    try {
      final batch = _db.batch();
      batch.set(_users.doc(user.uid), {
        ...profile.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (email.isNotEmpty) {
        batch.set(_lookup.doc('email_$email'), {
          'uid': user.uid,
          'authEmail': authEmail,
        });
      }
      await batch.commit();
    } catch (_) {
      // Gagal menyimpan: batalkan akun supaya tidak ada akun "setengah jadi".
      try {
        await user.delete();
      } catch (_) {}
      throw const AuthException(
          'Gagal menyimpan data akun. Periksa koneksi lalu coba lagi.');
    }

    return profile;
  }

  /// Login dengan email atau nomor HP. [role] adalah peran dari halaman
  /// login yang sedang dibuka; akun harus cocok dengan peran itu.
  Future<UserModel> login({
    required String identifier,
    required String password,
    required UserRole role,
  }) async {
    final id = identifier.trim();
    final String authEmail;

    if (id.contains('@')) {
      // Login dengan email asli: cari nomor HP pasangannya.
      final snap = await _lookup.doc('email_${id.toLowerCase()}').get();
      final data = snap.data();
      if (data == null) throw const AuthException(_wrongCredentials);
      authEmail = data['authEmail'] as String;
    } else {
      // Login dengan nomor HP.
      final phone = Validators.normalizePhone(id);
      if (phone == null) throw const AuthException('Nomor HP tidak valid.');
      authEmail = Validators.phoneToAuthEmail(phone);
    }

    final UserCredential cred;
    try {
      cred = await _auth.signInWithEmailAndPassword(
        email: authEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }

    // Periksa peran akun.
    final profile = await getProfile(cred.user!.uid);
    if (profile == null) {
      await _auth.signOut();
      throw const AuthException('Data akun tidak ditemukan.');
    }
    if (profile.role != role) {
      await _auth.signOut();
      throw AuthException(
        'Akun ini terdaftar sebagai ${profile.role.label}. '
        'Silakan masuk melalui halaman ${profile.role.label}.',
      );
    }
    return profile;
  }

  /// Keluar dari akun.
  Future<void> logout() => _auth.signOut();

  /// Menerjemahkan kode error Firebase menjadi pesan bahasa Indonesia.
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
        return _wrongCredentials;
      case 'email-already-in-use':
        return 'Nomor HP ini sudah terdaftar. Silakan masuk.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Gunakan minimal 8 karakter.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      default:
        return 'Terjadi kesalahan (${e.code}).';
    }
  }
}