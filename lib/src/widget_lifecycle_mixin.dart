import 'package:flutter/widgets.dart';

import 'lifecycle_event.dart';
import 'logger.dart';

mixin LifecycleAware<T extends StatefulWidget> on State<T> {
  @protected
  void onInit() {}

  @protected
  void onDispose() {}

  @override
  void initState() {
    super.initState();
    LifecycleLog.emit(
      LifecycleEvent(
        type: LifecycleEventType.widgetInitState,
        message: '${widget.runtimeType} initState',
        timestamp: DateTime.now(),
        widgetName: widget.runtimeType.toString(),
      ),
    );
    onInit();
  }

  @override
  void dispose() {
    LifecycleLog.emit(
      LifecycleEvent(
        type: LifecycleEventType.widgetDispose,
        message: '${widget.runtimeType} dispose',
        timestamp: DateTime.now(),
        widgetName: widget.runtimeType.toString(),
      ),
    );
    onDispose();
    super.dispose();
  }
}
