import 'package:material_ui/material_ui.dart';

import '../../models/user_role.dart';
import '../../widgets/role_home_scaffold.dart';

/// Beranda Pemberi Kerja (kosong, placeholder tahap 1).
class EmployerHome extends StatelessWidget {
  const EmployerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoleHomeScaffold(
      role: UserRole.employer,
      title: 'Beranda Pemberi Kerja',
    );
  }
}