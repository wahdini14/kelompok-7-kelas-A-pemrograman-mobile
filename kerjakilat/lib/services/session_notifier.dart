import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import 'auth_service.dart';

/// Menyimpan siapa yang sedang login (profil + peran).
/// Router "mendengarkan" kelas ini: ketika profil berubah,
/// pengguna otomatis dipindahkan ke halaman yang sesuai.
class SessionNotifier extends ChangeNotifier {
  SessionNotifier(this._auth);

  final AuthService _auth;
  UserModel? _profile;

  /// Profil pengguna yang login. Null berarti belum login.
  UserModel? get profile => _profile;

  /// Dipanggil sekali saat aplikasi dibuka untuk memulihkan sesi
  /// (Firebase menyimpan login di perangkat).
  Future<void> restore() async {
    try {
      final user = await _auth.authStateChanges.first;
      if (user == null) return;

      final profile = await _auth.getProfile(user.uid);
      if (profile == null) {
        // Akun ada tetapi datanya tidak ada: keluarkan agar tidak nyangkut.
        await _auth.logout();
        return;
      }
      _profile = profile;
    } catch (e) {
      // Gagal memuat (misalnya tidak ada internet): anggap belum login.
      debugPrint('Gagal memulihkan sesi: $e');
    }
  }

  /// Dipanggil setelah login/register berhasil (atau null saat logout).
  void setProfile(UserModel? profile) {
    _profile = profile;
    notifyListeners();
  }

  /// Keluar dari akun lalu kembali ke halaman Pilih Peran.
  Future<void> logout() async {
    await _auth.logout();
    setProfile(null);
  }
}