import 'package:flutter/material.dart';
import 'package:lifecycle_logger/lifecycle_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LifecycleLogger.attach(
    onResume: () => debugPrint('[Lifecycle] Example callback onResume'),
    onPause: () => debugPrint('[Lifecycle] Example callback onPause'),
    onInactive: () => debugPrint('[Lifecycle] Example callback onInactive'),
    onDetached: () => debugPrint('[Lifecycle] Example callback onDetached'),
  );
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _ExampleHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ExampleHome extends StatefulWidget {
  const _ExampleHome();

  @override
  State<_ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<_ExampleHome> {
  var _showProbe = true;

  void _toggleProbe() {
    setState(() {
      _showProbe = !_showProbe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('lifecycle_logger example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Watch debug console for lifecycle logs.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _toggleProbe,
              child: Text(_showProbe ? 'Dispose probe' : 'Create probe'),
            ),
            const SizedBox(height: 12),
            if (_showProbe) const _LifecycleProbe(),
          ],
        ),
      ),
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
    debugPrint('[Lifecycle] _LifecycleProbe onInit hook fired');
  }

  @override
  void onDispose() {
    debugPrint('[Lifecycle] _LifecycleProbe onDispose hook fired');
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Probe mounted (uses LifecycleAware)');
  }
}
