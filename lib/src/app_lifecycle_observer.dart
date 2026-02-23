import 'package:flutter/widgets.dart';

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
        LifecycleLog.log('App resumed');
        onResume?.call();
        break;
      case AppLifecycleState.inactive:
        LifecycleLog.log('App inactive');
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        LifecycleLog.log('App paused');
        onPause?.call();
        break;
      case AppLifecycleState.detached:
        LifecycleLog.log('App detached');
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
