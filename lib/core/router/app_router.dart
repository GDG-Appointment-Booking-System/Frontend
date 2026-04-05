import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/pages/admin_dashboard_page.dart';
import 'package:frontend/pages/booking_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/manage_services_page.dart';
import 'package:frontend/pages/my_appointments_page.dart';
import 'package:frontend/pages/not_found_page.dart';
import 'package:frontend/pages/services_page.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final session = authState.valueOrNull;

  return GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.services,
        name: 'services',
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: RouteNames.booking,
        name: 'booking',
        builder: (context, state) => const BookingPage(),
      ),
      GoRoute(
        path: RouteNames.myAppointments,
        name: 'my_appointments',
        builder: (context, state) => const MyAppointmentsPage(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.adminManageServices,
        name: 'admin_manage_services',
        builder: (context, state) => const ManageServicesPage(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) {
      final location = state.uri.toString();
      final isLoggedIn = session != null;
      final role = session?.user.role;

      final isAuthPage = location == RouteNames.login;
      final isClientPage = location.startsWith('/client/');
      final isAdminPage = location.startsWith('/admin/');

      if (!isLoggedIn && !isAuthPage) {
        return RouteNames.login;
      }

      if (isLoggedIn && isAuthPage) {
        if (role == UserRole.admin.name) return RouteNames.adminDashboard;
        return RouteNames.services;
      }

      if (isLoggedIn && role == UserRole.client.name && isAdminPage) {
        return RouteNames.services;
      }

      if (isLoggedIn && role == UserRole.admin.name && isClientPage) {
        return RouteNames.adminDashboard;
      }

      return null;
    },
  );
});
