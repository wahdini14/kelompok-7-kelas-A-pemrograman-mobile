import 'package:flutter/material.dart';

/// Logo KerjaKilat: ikon petir di dalam kotak membulat.
/// Dipakai ulang di Splash dan halaman Login/Register.
class AppLogoBox extends StatelessWidget {
  final double size;
  final Color boxColor;
  final Color iconColor;
  final bool withShadow;

  const AppLogoBox({
    super.key,
    this.size = 40,
    this.boxColor = Colors.white,
    required this.iconColor,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Icon(Icons.bolt_rounded, color: iconColor, size: size * 0.58),
    );
  }
}