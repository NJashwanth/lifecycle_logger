import 'package:flutter/widgets.dart';
import 'package:lifecycle_logger/lifecycle_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LifecycleLogger.attach();
  runApp(const _ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  const _ExampleApp();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: _LifecycleProbe(),
    );
  }
}

class _LifecycleProbe extends StatefulWidget {
  const _LifecycleProbe();

  @override
  State<_LifecycleProbe> createState() => _LifecycleProbeState();
}

class _LifecycleProbeState extends State<_LifecycleProbe>
    with LifecycleAware<_LifecycleProbe> {
  @override
  void onInit() {
    debugPrint('[Lifecycle] _LifecycleProbe onInit hook');
  }

  @override
  void onDispose() {
    debugPrint('[Lifecycle] _LifecycleProbe onDispose hook');
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
