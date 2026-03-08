import 'package:flutter/foundation.dart';

import 'lifecycle_event.dart';

typedef LifecycleEventSink = void Function(LifecycleEvent event);

class LifecycleLog {
  LifecycleLog._();

  static const String _defaultTag = '[Lifecycle]';
  static LifecycleEventSink? _sink;
  static bool _logToConsole = true;
  static String _tag = _defaultTag;

  static void configure({
    LifecycleEventSink? sink,
    bool? logToConsole,
    String? tag,
  }) {
    _sink = sink;
    if (logToConsole != null) {
      _logToConsole = logToConsole;
    }
    if (tag != null && tag.isNotEmpty) {
      _tag = tag;
    }
  }

  static void reset() {
    _sink = null;
    _logToConsole = true;
    _tag = _defaultTag;
  }

  static void emit(LifecycleEvent event) {
    if (_logToConsole) {
      debugPrint('$_tag ${event.message}');
    }
    _sink?.call(event);
  }
}
