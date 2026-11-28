import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../models/user_role.dart';
import '../../widgets/role_card.dart';

/// Halaman untuk memilih peran sebelum login atau register.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo kecil
              const Row(
                children: [
                  Icon(Icons.bolt_rounded, color: AppColors.seeker, size: 22),
                  SizedBox(width: 6),
                  Text(
                    'KerjaKilat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.seeker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Kamu mau apa\ndi Kerja Kilat?',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pilih peran, lalu masuk atau buat akun.',
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              const SizedBox(height: 28),

              // Kartu Pencari Kerja
              RoleCard(
                color: AppColors.seeker,
                lightColor: AppColors.seekerLight,
                icon: Icons.zoom_in_rounded,
                title: 'Saya mencari kerja',
                description:
                    'Lihat pekerjaan harian di sekitarmu, lamar sekali ketuk, '
                    'dan pantau status lamaran.',
                actionText: 'Masuk atau daftar sebagai pencari kerja',
                badge: 'Paling banyak dipilih',
                onTap: () => context.push('/login/${UserRole.jobSeeker.value}'),
              ),
              const SizedBox(height: 16),

              // Kartu Pemberi Kerja
              RoleCard(
                color: AppColors.employer,
                lightColor: AppColors.employerLight,
                icon: Icons.person_add_alt_1_outlined,
                title: 'Saya mencari pekerja',
                description:
                    'Posting pekerjaan dalam 1 menit, lihat pelamar terdekat, '
                    'lalu terima yang paling cocok.',
                actionText: 'Masuk atau daftar sebagai pemberi kerja',
                onTap: () => context.push('/login/${UserRole.employer.value}'),
              ),
              const SizedBox(height: 18),

              // Informasi di bagian bawah
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.info_outline,
                        size: 16, color: AppColors.textGrey),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Satu akun hanya untuk satu peran. Butuh keduanya? '
                      'Daftar akun kedua dengan email yang berbeda.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}