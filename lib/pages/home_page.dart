import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SharpCut MVP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Use this screen as a temporary starter. '
              'In production you can replace it with a splash/landing screen.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.login),
              child: const Text('Go To Login'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.services),
              child: const Text('Go To Services (Dev Shortcut)'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Once the backend login endpoints are fully hooked up, you can '
              'remove these developer shortcuts.',
            ),
          ],
        ),
      ),
    );
  }
}
