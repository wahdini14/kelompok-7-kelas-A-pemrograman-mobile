import 'package:flutter/material.dart';

import '../models/user_role.dart';

/// Kumpulan warna KerjaKilat.
/// Biru/ungu untuk Pencari Kerja, hijau untuk Pemberi Kerja.
class AppColors {
  AppColors._();

  // Warna utama per peran (sesuai wireframe)
  static const Color seeker = Color(0xFF5060E0);
  static const Color employer = Color(0xFF109276);

  // Versi terang (latar ikon, kartu info, dll.)
  static const Color seekerLight = Color(0xFFE8EAFB);
  static const Color employerLight = Color(0xFFDDF3EC);

  // Warna umum
  static const Color background = Color(0xFFF4F5FA);
  static const Color textDark = Color(0xFF1B1D2E);
  static const Color textGrey = Color(0xFF6B7080);

  /// Mengambil warna utama sesuai peran.
  static Color forRole(UserRole role) =>
      role == UserRole.jobSeeker ? seeker : employer;

  /// Mengambil warna terang sesuai peran.
  static Color lightForRole(UserRole role) =>
      role == UserRole.jobSeeker ? seekerLight : employerLight;
}