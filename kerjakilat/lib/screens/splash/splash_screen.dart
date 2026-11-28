import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_logo_box.dart';

/// Halaman pembuka. Tombol "Mulai" menuju halaman Pilih Peran.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Lingkaran dekoratif transparan
  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.seeker,
      body: Stack(
        children: [
          Positioned(top: -70, right: -70, child: _circle(230)),
          Positioned(bottom: -90, left: -80, child: _circle(250)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // Logo dan teks berada di tengah halaman
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppLogoBox(
                            size: 86,
                            iconColor: AppColors.seeker,
                            withShadow: true,
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'KerjaKilat',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kerja harian, secepat kilat',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tombol Mulai di bagian bawah
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.seeker,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => context.go('/role'),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}