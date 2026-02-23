import 'package:flutter/foundation.dart';

class LifecycleLog {
  LifecycleLog._();

  static const String _prefix = '[Lifecycle]';

  static void log(String message) {
    debugPrint('$_prefix $message');
  }
}
