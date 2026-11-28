import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/app_colors.dart';
import '../models/user_role.dart';
import 'app_logo_box.dart';

/// Kerangka halaman Login dan Register untuk kedua peran:
/// header berwarna, kartu form putih yang menimpa header,
/// tautan pindah halaman, dan kartu info di bagian bawah.
/// Warna mengikuti [role].
class AuthScaffold extends StatelessWidget {
  final UserRole role;
  final String title;
  final String subtitle;
  final Widget formCard; // isi kartu putih
  final String switchText; // contoh: "Belum punya akun?"
  final String switchLinkText; // contoh: "Buat akun pencari kerja"
  final VoidCallback onSwitchTap;
  final String infoText;
  final String infoLinkText;
  final VoidCallback onInfoTap;

  const AuthScaffold({
    super.key,
    required this.role,
    required this.title,
    required this.subtitle,
    required this.formCard,
    required this.switchText,
    required this.switchLinkText,
    required this.onSwitchTap,
    required this.infoText,
    required this.infoLinkText,
    required this.onInfoTap,
  });

  // Seberapa jauh kartu putih menimpa header
  static const double _overlap = 56;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forRole(role);
    final other = role == UserRole.jobSeeker
        ? UserRole.employer
        : UserRole.jobSeeker;
    final otherColor = AppColors.forRole(other);

    return Scaffold(
      // Latar sangat terang dengan nuansa warna peran
      backgroundColor:
          Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // SingleChildScrollView: halaman bisa di-scroll saat layar kecil
          // atau saat keyboard muncul.
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildHeader(context, color),

                    // Kartu form + tautan, digeser ke atas agar menimpa header
                    Transform.translate(
                      offset: const Offset(0, -_overlap),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: formCard,
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '$switchText ',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onSwitchTap,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: Text(
                                      switchLinkText,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Kartu info di bagian bawah (warna peran lawan)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: SafeArea(
                        top: false,
                        child: Material(
                          color: AppColors.lightForRole(other),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: onInfoTap,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          infoText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: otherColor.withValues(
                                                alpha: 0.85),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          infoLinkText,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: otherColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,
                                      size: 20, color: otherColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Tombol kembali: mundur jika bisa, kalau tidak ke halaman Pilih Peran.
  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/role');
    }
  }

  Widget _buildChip() {
    final isSeeker = role == UserRole.jobSeeker;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSeeker ? Icons.search : Icons.person_add_alt_1_outlined,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            role.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    final isSeeker = role == UserRole.jobSeeker;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Lingkaran dekoratif kanan atas
          Positioned(
            top: -60,
            right: -50,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, _overlap + 20),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Baris atas: tombol kembali dan label peran.
                  // Pencari kerja: label di kiri. Pemberi kerja: di kanan.
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _goBack(context),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          child: const Icon(Icons.chevron_left_rounded,
                              color: Colors.white, size: 26),
                        ),
                      ),
                      if (isSeeker) const SizedBox(width: 8) else const Spacer(),
                      _buildChip(),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      AppLogoBox(size: 34, iconColor: color),
                      const SizedBox(width: 10),
                      const Text(
                        'KerjaKilat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.white.withValues(alpha: 0.88),
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