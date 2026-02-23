import 'package:flutter/widgets.dart';

import 'logger.dart';

mixin LifecycleAware<T extends StatefulWidget> on State<T> {
  @protected
  void onInit() {}

  @protected
  void onDispose() {}

  @override
  void initState() {
    super.initState();
    LifecycleLog.log('${widget.runtimeType} initState');
    onInit();
  }

  @override
  void dispose() {
    LifecycleLog.log('${widget.runtimeType} dispose');
    onDispose();
    super.dispose();
  }
}
