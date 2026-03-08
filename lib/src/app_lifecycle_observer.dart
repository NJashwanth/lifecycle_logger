import 'package:flutter/widgets.dart';

import 'lifecycle_event.dart';
import 'logger.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver({
    this.onResume,
    this.onPause,
    this.onInactive,
    this.onDetached,
  });

  final void Function()? onResume;
  final void Function()? onPause;
  final void Function()? onInactive;
  final void Function()? onDetached;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        LifecycleLog.emit(
          LifecycleEvent(
            type: LifecycleEventType.appResumed,
            message: 'App resumed',
            timestamp: DateTime.now(),
            appState: state,
          ),
        );
        onResume?.call();
        break;
      case AppLifecycleState.inactive:
        LifecycleLog.emit(
          LifecycleEvent(
            type: LifecycleEventType.appInactive,
            message: 'App inactive',
            timestamp: DateTime.now(),
            appState: state,
          ),
        );
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        LifecycleLog.emit(
          LifecycleEvent(
            type: LifecycleEventType.appPaused,
            message: 'App paused',
            timestamp: DateTime.now(),
            appState: state,
          ),
        );
        onPause?.call();
        break;
      case AppLifecycleState.detached:
        LifecycleLog.emit(
          LifecycleEvent(
            type: LifecycleEventType.appDetached,
            message: 'App detached',
            timestamp: DateTime.now(),
            appState: state,
          ),
        );
        onDetached?.call();
        break;
      default:
        break;
    }
  }
}
