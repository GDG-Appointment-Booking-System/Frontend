import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex(),
      onDestinationSelected: (index) {
        final route = switch (index) {
          0 => RouteNames.adminDashboard,
          _ => RouteNames.adminManageServices,
        };

        if (route != currentRoute) {
          context.go(route);
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.analytics), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.tune), label: 'Services'),
      ],
    );
  }

  int _selectedIndex() {
    if (currentRoute.startsWith(RouteNames.adminManageServices)) return 1;
    return 0;
  }
}
