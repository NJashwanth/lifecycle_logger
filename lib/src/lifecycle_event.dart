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
    this.metadata,
  });

  final LifecycleEventType type;
  final String message;
  final DateTime timestamp;
  final AppLifecycleState? appState;
  final String? widgetName;
  final String? routeName;
  final String? previousRouteName;
  final Map<String, Object?>? metadata;

  LifecycleEvent copyWith({
    LifecycleEventType? type,
    String? message,
    DateTime? timestamp,
    AppLifecycleState? appState,
    String? widgetName,
    String? routeName,
    String? previousRouteName,
    Map<String, Object?>? metadata,
  }) {
    return LifecycleEvent(
      type: type ?? this.type,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      appState: appState ?? this.appState,
      widgetName: widgetName ?? this.widgetName,
      routeName: routeName ?? this.routeName,
      previousRouteName: previousRouteName ?? this.previousRouteName,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() => message;
}
