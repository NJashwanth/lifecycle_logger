import 'package:flutter/widgets.dart';

import 'lifecycle_event.dart';
import 'logger.dart';

typedef LifecycleTransitionCallback = void Function(
  AppLifecycleState? previous,
  AppLifecycleState current,
  LifecycleEvent event,
);

class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver({
    this.onResume,
    this.onPause,
    this.onInactive,
    this.onDetached,
    this.onStateTransition,
  });

  final void Function()? onResume;
  final void Function()? onPause;
  final void Function()? onInactive;
  final void Function()? onDetached;
  final LifecycleTransitionCallback? onStateTransition;
  AppLifecycleState? _previousState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LifecycleEvent? emittedEvent;

    switch (state) {
      case AppLifecycleState.resumed:
        emittedEvent = LifecycleEvent(
          type: LifecycleEventType.appResumed,
          message: 'App resumed',
          timestamp: DateTime.now(),
          appState: state,
        );
        LifecycleLog.emit(emittedEvent);
        onResume?.call();
        break;
      case AppLifecycleState.inactive:
        emittedEvent = LifecycleEvent(
          type: LifecycleEventType.appInactive,
          message: 'App inactive',
          timestamp: DateTime.now(),
          appState: state,
        );
        LifecycleLog.emit(emittedEvent);
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        emittedEvent = LifecycleEvent(
          type: LifecycleEventType.appPaused,
          message: 'App paused',
          timestamp: DateTime.now(),
          appState: state,
        );
        LifecycleLog.emit(emittedEvent);
        onPause?.call();
        break;
      case AppLifecycleState.detached:
        emittedEvent = LifecycleEvent(
          type: LifecycleEventType.appDetached,
          message: 'App detached',
          timestamp: DateTime.now(),
          appState: state,
        );
        LifecycleLog.emit(emittedEvent);
        onDetached?.call();
        break;
      default:
        break;
    }

    if (emittedEvent != null) {
      onStateTransition?.call(_previousState, state, emittedEvent);
      _previousState = state;
    }
  }
}
