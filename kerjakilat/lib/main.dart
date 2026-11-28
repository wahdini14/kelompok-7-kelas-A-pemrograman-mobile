import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'services/auth_service.dart';
import 'services/session_notifier.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum memakai Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Menyambungkan aplikasi ke Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();

  // Pulihkan sesi login (jika pengguna sebelumnya sudah login)
  final session = SessionNotifier(authService);
  await session.restore();

  final router = createAppRouter(session);

  runApp(KerjaKilatApp(
    authService: authService,
    session: session,
    router: router,
  ));
}

class KerjaKilatApp extends StatelessWidget {
  final AuthService authService;
  final SessionNotifier session;
  final GoRouter router;

  const KerjaKilatApp({
    super.key,
    required this.authService,
    required this.session,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    // AuthService dan SessionNotifier dibagikan ke semua halaman
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider<SessionNotifier>.value(value: session),
      ],
      child: MaterialApp.router(
        title: 'KerjaKilat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}