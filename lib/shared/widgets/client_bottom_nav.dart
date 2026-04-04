import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class ClientBottomNav extends StatelessWidget {
  const ClientBottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex(),
      onDestinationSelected: (index) {
        final route = switch (index) {
          0 => RouteNames.services,
          1 => RouteNames.booking,
          _ => RouteNames.myAppointments,
        };

        if (route != currentRoute) {
          context.go(route);
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.content_cut), label: 'Services'),
        NavigationDestination(
          icon: Icon(Icons.calendar_month),
          label: 'Book',
        ),
        NavigationDestination(icon: Icon(Icons.event_note), label: 'My Bookings'),
      ],
    );
  }

  int _selectedIndex() {
    if (currentRoute.startsWith(RouteNames.booking)) return 1;
    if (currentRoute.startsWith(RouteNames.myAppointments)) return 2;
    return 0;
  }
}
