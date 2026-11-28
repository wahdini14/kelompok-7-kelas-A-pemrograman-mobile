import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/employer_home.dart';
import '../screens/home/job_seeker_home.dart';
import '../screens/role_selection/role_selection_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../services/session_notifier.dart';

/// Daftar halaman dan aturan akses.
/// Router dibuat dengan [session] agar bisa memeriksa status login.
GoRouter createAppRouter(SessionNotifier session) {
  return GoRouter(
    initialLocation: '/',
    // Router dievaluasi ulang setiap kali status login berubah
    refreshListenable: session,
    redirect: (context, state) {
      final profile = session.profile;
      final loc = state.matchedLocation;
      final isHome = loc.startsWith('/home');

      // Belum login: beranda tidak boleh dibuka
      if (profile == null) {
        return isHome ? '/role' : null;
      }

      // Sudah login: Splash, Pilih Peran, Login, Register dilewati.
      final myHome = '/home/${profile.role.value}';
      if (!isHome) return myHome;

      // Sudah login tetapi mencoba membuka beranda peran lain
      if (loc != myHome) return myHome;

      return null;
    },
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
        builder: (context, state) => LoginScreen(
          role: UserRole.fromValue(state.pathParameters['role'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/register/:role',
        builder: (context, state) => RegisterScreen(
          role: UserRole.fromValue(state.pathParameters['role'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/home/:role',
        builder: (context, state) {
          final role = UserRole.fromValue(state.pathParameters['role'] ?? '');
          return role == UserRole.employer
              ? const EmployerHome()
              : const JobSeekerHome();
        },
      ),
    ],
  );
}