import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../screens/auth/login_screen.dart';
import '../screens/role_selection/role_selection_screen.dart';
import '../screens/splash/splash_screen.dart';

/// Daftar halaman dan alamatnya.
/// Halaman lain ditambahkan di langkah berikutnya.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/role',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login/:role',
      builder: (context, state) {
        final role = UserRole.fromValue(state.pathParameters['role'] ?? '');
        return LoginScreen(role: role);
      },
    ),
  ],
);