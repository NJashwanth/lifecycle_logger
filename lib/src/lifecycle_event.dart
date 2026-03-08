import 'package:flutter/widgets.dart';

enum LifecycleEventType {
  appResumed,
  appInactive,
  appPaused,
  appDetached,
  widgetInitState,
  widgetDispose,
  routePush,
  routePop,
  routeRemove,
  routeReplace,
}

class LifecycleEvent {
  const LifecycleEvent({
    required this.type,
    required this.message,
    required this.timestamp,
    this.appState,
    this.widgetName,
    this.routeName,
    this.previousRouteName,
  });

  final LifecycleEventType type;
  final String message;
  final DateTime timestamp;
  final AppLifecycleState? appState;
  final String? widgetName;
  final String? routeName;
  final String? previousRouteName;

  @override
  String toString() => message;
}
