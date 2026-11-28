import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum memakai Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Menyambungkan aplikasi ke Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const KerjaKilatApp());
}

class KerjaKilatApp extends StatelessWidget {
  const KerjaKilatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthService dibagikan ke semua halaman lewat Provider
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp.router(
        title: 'KerjaKilat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}