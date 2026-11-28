import 'package:material_ui/material_ui.dart';

import '../../models/user_role.dart';
import '../../widgets/role_home_scaffold.dart';

/// Beranda Pencari Kerja (kosong, placeholder tahap 1).
class JobSeekerHome extends StatelessWidget {
  const JobSeekerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoleHomeScaffold(
      role: UserRole.jobSeeker,
      title: 'Beranda Pencari Kerja',
    );
  }
}