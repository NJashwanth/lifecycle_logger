import 'package:flutter/widgets.dart';

import 'lifecycle_event.dart';
import 'logger.dart';

class LifecycleRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  LifecycleRouteObserver({this.enabled = false});

  bool enabled;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (enabled) {
      LifecycleLog.emit(
        LifecycleEvent(
          type: LifecycleEventType.routePush,
          message: 'Route pushed: ${_routeName(route)}',
          timestamp: DateTime.now(),
          routeName: _routeName(route),
          previousRouteName: _routeName(previousRoute),
        ),
      );
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (enabled) {
      LifecycleLog.emit(
        LifecycleEvent(
          type: LifecycleEventType.routePop,
          message: 'Route popped: ${_routeName(route)}',
          timestamp: DateTime.now(),
          routeName: _routeName(route),
          previousRouteName: _routeName(previousRoute),
        ),
      );
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (enabled) {
      LifecycleLog.emit(
        LifecycleEvent(
          type: LifecycleEventType.routeRemove,
          message: 'Route removed: ${_routeName(route)}',
          timestamp: DateTime.now(),
          routeName: _routeName(route),
          previousRouteName: _routeName(previousRoute),
        ),
      );
    }
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (enabled) {
      LifecycleLog.emit(
        LifecycleEvent(
          type: LifecycleEventType.routeReplace,
          message:
              'Route replaced: ${_routeName(oldRoute)} -> ${_routeName(newRoute)}',
          timestamp: DateTime.now(),
          routeName: _routeName(newRoute),
          previousRouteName: _routeName(oldRoute),
        ),
      );
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  String _routeName(Route<dynamic>? route) {
    if (route == null) {
      return '<none>';
    }
    final routeName = route.settings.name;
    if (routeName != null && routeName.isNotEmpty) {
      return routeName;
    }
    return route.runtimeType.toString();
  }
}
