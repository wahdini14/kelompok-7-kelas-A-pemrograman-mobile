import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../models/user_role.dart';

/// SEMENTARA: akan diganti dengan halaman Login sebenarnya di Langkah 4.
class LoginScreen extends StatelessWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forRole(role);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(role.label),
      ),
      body: Center(child: Text('Login ${role.label} (sementara)')),
    );
  }
}