import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48),
            const SizedBox(height: 12),
            const Text('The page you requested does not exist.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.login),
              child: const Text('Back To Login'),
            ),
          ],
        ),
      ),
    );
  }
}
