import 'package:flutter/widgets.dart';

import 'src/app_lifecycle_observer.dart';
import 'src/logger.dart';
import 'src/route_lifecycle_observer.dart';

export 'src/widget_lifecycle_mixin.dart' show LifecycleAware;
export 'src/lifecycle_event.dart' show LifecycleEvent, LifecycleEventType;
export 'src/logger.dart' show LifecycleEventSink;
export 'src/route_lifecycle_observer.dart' show LifecycleRouteObserver;

class LifecycleLogger {
  LifecycleLogger._();

  static AppLifecycleObserver? _observer;
  static final LifecycleRouteObserver _routeObserver = LifecycleRouteObserver();
  static bool _attached = false;

  static NavigatorObserver get routeObserver => _routeObserver;

  static void attach({
    bool debugOnly = true,
    bool enableRouteObserver = false,
    bool logToConsole = true,
    String tag = '[Lifecycle]',
    LifecycleEventSink? sink,
    void Function()? onResume,
    void Function()? onPause,
    void Function()? onInactive,
    void Function()? onDetached,
  }) {
    if (debugOnly && !_isDebugMode) {
      return;
    }

    LifecycleLog.configure(sink: sink, logToConsole: logToConsole, tag: tag);
    _routeObserver.enabled = enableRouteObserver;

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
    _routeObserver.enabled = false;
    LifecycleLog.reset();
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
