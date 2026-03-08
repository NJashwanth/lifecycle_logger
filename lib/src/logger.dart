import 'package:flutter/foundation.dart';

import 'lifecycle_event.dart';

typedef LifecycleEventSink = void Function(LifecycleEvent event);

class LifecycleLog {
  LifecycleLog._();

  static const String _prefix = '[Lifecycle]';
  static LifecycleEventSink? _sink;
  static bool _logToConsole = true;

  static void configure({LifecycleEventSink? sink, bool? logToConsole}) {
    _sink = sink;
    if (logToConsole != null) {
      _logToConsole = logToConsole;
    }
  }

  static void reset() {
    _sink = null;
    _logToConsole = true;
  }

  static void emit(LifecycleEvent event) {
    if (_logToConsole) {
      debugPrint('$_prefix ${event.message}');
    }
    _sink?.call(event);
  }
}
