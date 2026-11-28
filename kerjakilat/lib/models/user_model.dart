import 'user_role.dart';

/// Data akun pengguna yang disimpan di Firestore (koleksi "users").
class UserModel {
  final String uid;
  final String fullName;
  final String phone; // format standar, contoh: 6281234567890
  final String email; // boleh kosong
  final UserRole role;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.role,
  });

  /// Membuat UserModel dari data Firestore.
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      fullName: (map['fullName'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      role: UserRole.fromValue((map['role'] ?? '') as String),
    );
  }

  /// Mengubah UserModel menjadi data untuk disimpan ke Firestore.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'role': role.value,
    };
  }
}