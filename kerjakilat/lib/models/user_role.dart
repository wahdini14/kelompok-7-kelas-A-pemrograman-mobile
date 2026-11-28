/// Dua peran pengguna di KerjaKilat.
/// Satu akun hanya memiliki satu peran.
enum UserRole {
  jobSeeker, // Pencari Kerja
  employer; // Pemberi Kerja

  /// Nilai yang dipakai di URL dan database.
  String get value => this == UserRole.jobSeeker ? 'job_seeker' : 'employer';

  /// Nama yang ditampilkan ke pengguna.
  String get label =>
      this == UserRole.jobSeeker ? 'Pencari Kerja' : 'Pemberi Kerja';

  /// Mengubah teks (dari URL/database) menjadi peran.
  static UserRole fromValue(String value) {
    return value == 'employer' ? UserRole.employer : UserRole.jobSeeker;
  }
}