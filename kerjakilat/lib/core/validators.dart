/// Kumpulan aturan validasi input dan pengolah nomor HP.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const String _phoneError =
      'Nomor HP tidak valid. Contoh: 0812-3456-7890.';

  // ---------- Validasi untuk form ----------

  static String? fullName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Nama lengkap wajib diisi.';
    if (v.length < 3) return 'Nama lengkap minimal 3 karakter.';
    return null;
  }

  static String? phone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Nomor HP wajib diisi.';
    if (normalizePhone(v) == null) return _phoneError;
    return null;
  }

  /// Email pada form Register bersifat opsional.
  static String? optionalEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return null;
    if (!_emailRegex.hasMatch(v)) return 'Format email tidak valid.';
    return null;
  }

  /// Kolom login "Email atau nomor HP".
  static String? loginIdentifier(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email atau nomor HP wajib diisi.';
    if (v.contains('@')) {
      return _emailRegex.hasMatch(v) ? null : 'Format email tidak valid.';
    }
    return normalizePhone(v) == null ? _phoneError : null;
  }

  /// Kata sandi baru (form Register): minimal 8 karakter.
  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Kata sandi wajib diisi.';
    if (v.length < 8) return 'Kata sandi minimal 8 karakter.';
    return null;
  }

  /// Kata sandi saat login: cukup tidak kosong.
  static String? loginPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Kata sandi wajib diisi.';
    return null;
  }

  // ---------- Pengolah nomor HP ----------

  /// Mengubah nomor HP ke format standar Indonesia.
  /// "0812-3456-7890" dan "+62 812 3456 7890" menjadi "6281234567890".
  /// Mengembalikan null jika nomor tidak valid.
  static String? normalizePhone(String input) {
    var digits = input.trim().replaceAll(RegExp(r'[\s\-().+]'), '');
    if (!RegExp(r'^\d+$').hasMatch(digits)) return null;

    if (digits.startsWith('0')) {
      digits = '62${digits.substring(1)}';
    } else if (digits.startsWith('8')) {
      digits = '62$digits';
    }

    // Nomor seluler Indonesia: 628 + 8 sampai 11 angka
    return RegExp(r'^628\d{8,11}$').hasMatch(digits) ? digits : null;
  }

  /// Email internal untuk Firebase Auth (tidak pernah dilihat pengguna).
  static String phoneToAuthEmail(String normalizedPhone) {
    return '$normalizedPhone@phone.kerjakilat.app';
  }
}