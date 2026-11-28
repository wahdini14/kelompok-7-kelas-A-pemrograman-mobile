import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/user_role.dart';
import '../services/session_notifier.dart';
import 'app_logo_box.dart';

/// Kerangka beranda kosong untuk kedua peran (placeholder tahap 1).
/// Ada tombol keluar di pojok kanan atas untuk menguji sesi.
class RoleHomeScaffold extends StatelessWidget {
  final UserRole role;
  final String title;

  const RoleHomeScaffold({super.key, required this.role, required this.title});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forRole(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            AppLogoBox(size: 30, iconColor: color),
            const SizedBox(width: 10),
            const Text(
              'KerjaKilat',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<SessionNotifier>().logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoBox(
              size: 72,
              boxColor: AppColors.lightForRole(role),
              iconColor: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}