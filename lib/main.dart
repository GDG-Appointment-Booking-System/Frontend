import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/theme/app_theme.dart';

void main() {
  // Riverpod must wrap the app so providers can be read anywhere.
  runApp(const ProviderScope(child: SharpCutApp()));
}

class SharpCutApp extends ConsumerWidget {
  const SharpCutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SharpCut',
      theme: sharpCutTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
