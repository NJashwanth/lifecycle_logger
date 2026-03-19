import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'src/app_lifecycle_observer.dart';
import 'src/lifecycle_event.dart';
import 'src/logger.dart';
import 'src/route_lifecycle_observer.dart';

export 'src/widget_lifecycle_mixin.dart' show LifecycleAware;
export 'src/lifecycle_event.dart' show LifecycleEvent, LifecycleEventType;
export 'src/logger.dart'
    show LifecycleEventFilter, LifecycleEventSink, LifecycleSinkErrorHandler;
export 'src/route_lifecycle_observer.dart' show LifecycleRouteObserver;
export 'src/app_lifecycle_observer.dart' show LifecycleTransitionCallback;

class LifecycleLogger {
  LifecycleLogger._();

  static AppLifecycleObserver? _observer;
  static final LifecycleRouteObserver _routeObserver = LifecycleRouteObserver();
  static bool _attached = false;

  static NavigatorObserver get routeObserver => _routeObserver;
  static Stream<LifecycleEvent> get events => LifecycleLog.eventStream;
  static ValueListenable<LifecycleEvent?> get latestEvent =>
      LifecycleLog.eventListenable;

  static void attach({
    bool debugOnly = true,
    bool enableRouteObserver = false,
    bool logToConsole = true,
    String tag = '[Lifecycle]',
    LifecycleEventSink? sink,
    LifecycleEventSink? onEvent,
    LifecycleEventFilter? filter,
    LifecycleSinkErrorHandler? onSinkError,
    Set<LifecycleEventType>? includeTypes,
    Set<LifecycleEventType>? excludeTypes,
    Set<String>? includeWidgetNames,
    Set<String>? excludeWidgetNames,
    Set<String>? includeRouteNames,
    Set<String>? excludeRouteNames,
    Map<String, Object?>? metadata,
    void Function()? onResume,
    void Function()? onPause,
    void Function()? onInactive,
    void Function()? onDetached,
    LifecycleTransitionCallback? onStateTransition,
  }) {
    if (debugOnly && !_isDebugMode) {
      return;
    }

    final effectiveFilter = _buildFilter(
      customFilter: filter,
      includeTypes: includeTypes,
      excludeTypes: excludeTypes,
      includeWidgetNames: includeWidgetNames,
      excludeWidgetNames: excludeWidgetNames,
      includeRouteNames: includeRouteNames,
      excludeRouteNames: excludeRouteNames,
    );

    LifecycleLog.configure(
      sink: sink,
      onEvent: onEvent,
      filter: effectiveFilter,
      onSinkError: onSinkError,
      metadata: metadata,
      logToConsole: logToConsole,
      tag: tag,
    );
    _routeObserver.enabled = enableRouteObserver;

    if (_attached) {
      return;
    }

    _observer = AppLifecycleObserver(
      onResume: onResume,
      onPause: onPause,
      onInactive: onInactive,
      onDetached: onDetached,
      onStateTransition: onStateTransition,
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

  static LifecycleEventFilter _buildFilter({
    LifecycleEventFilter? customFilter,
    Set<LifecycleEventType>? includeTypes,
    Set<LifecycleEventType>? excludeTypes,
    Set<String>? includeWidgetNames,
    Set<String>? excludeWidgetNames,
    Set<String>? includeRouteNames,
    Set<String>? excludeRouteNames,
  }) {
    final hasConstraints = includeTypes != null ||
        excludeTypes != null ||
        includeWidgetNames != null ||
        excludeWidgetNames != null ||
        includeRouteNames != null ||
        excludeRouteNames != null;

    if (!hasConstraints && customFilter == null) {
      return (_) => true;
    }

    return (event) {
      if (includeTypes != null && !includeTypes.contains(event.type)) {
        return false;
      }
      if (excludeTypes != null && excludeTypes.contains(event.type)) {
        return false;
      }
      if (includeWidgetNames != null &&
          !includeWidgetNames.contains(event.widgetName)) {
        return false;
      }
      if (excludeWidgetNames != null &&
          excludeWidgetNames.contains(event.widgetName)) {
        return false;
      }
      if (includeRouteNames != null &&
          !includeRouteNames.contains(event.routeName)) {
        return false;
      }
      if (excludeRouteNames != null &&
          excludeRouteNames.contains(event.routeName)) {
        return false;
      }

      return customFilter?.call(event) ?? true;
    };
  }
}
