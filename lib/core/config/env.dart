import 'package:flutter/foundation.dart';

class Env {
  Env._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:3000',
      _ => 'http://localhost:3000',
    };
  }
}
