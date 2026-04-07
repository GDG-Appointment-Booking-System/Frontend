import 'package:flutter/foundation.dart';

class Env {
  Env._();

  static String get baseUrl {
    if (isProd) {
      return 'https://gdg-appointment-booking-system.onrender.com/api';
    }
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:3000',
      _ => 'http://localhost:3000',
    };
  }
}
