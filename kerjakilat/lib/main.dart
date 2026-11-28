import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

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
    return MaterialApp.router(
      title: 'KerjaKilat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}