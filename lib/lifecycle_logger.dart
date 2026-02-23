library;

import 'package:flutter/widgets.dart';

import 'src/app_lifecycle_observer.dart';

export 'src/widget_lifecycle_mixin.dart' show LifecycleAware;

class LifecycleLogger {
  LifecycleLogger._();

  static AppLifecycleObserver? _observer;
  static bool _attached = false;

  static void attach({
    bool debugOnly = true,
    void Function()? onResume,
    void Function()? onPause,
    void Function()? onInactive,
    void Function()? onDetached,
  }) {
    if (debugOnly && !_isDebugMode) {
      return;
    }

    if (_attached) {
      return;
    }

    _observer = AppLifecycleObserver(
      onResume: onResume,
      onPause: onPause,
      onInactive: onInactive,
      onDetached: onDetached,
    );

    WidgetsBinding.instance.addObserver(_observer!);
    _attached = true;
  }

  static void detach() {
    if (!_attached || _observer == null) {
      return;
    }

    WidgetsBinding.instance.removeObserver(_observer!);
    _observer = null;
    _attached = false;
  }

  static bool get _isDebugMode {
    var isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }
}
