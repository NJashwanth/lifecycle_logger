import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lifecycle_logger/lifecycle_logger.dart';

final ValueNotifier<List<LifecycleEvent>> _eventsNotifier =
    ValueNotifier<List<LifecycleEvent>>(<LifecycleEvent>[]);

void _recordEvent(LifecycleEvent event) {
  void apply() {
    final current = _eventsNotifier.value;
    final next = <LifecycleEvent>[event, ...current];
    _eventsNotifier.value = next.take(30).toList();
  }

  final phase = WidgetsBinding.instance.schedulerPhase;
  if (phase == SchedulerPhase.idle ||
      phase == SchedulerPhase.postFrameCallbacks) {
    apply();
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    apply();
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LifecycleLogger.attach(
    debugOnly: false,
    enableRouteObserver: true,
    tag: '[AppLifecycle]',
    sink: _recordEvent,
    onResume: () => debugPrint('[AppLifecycle] Example callback onResume'),
    onPause: () => debugPrint('[AppLifecycle] Example callback onPause'),
    onInactive: () => debugPrint('[AppLifecycle] Example callback onInactive'),
    onDetached: () => debugPrint('[AppLifecycle] Example callback onDetached'),
  );
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [LifecycleLogger.routeObserver],
      home: const _ExampleHome(),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trigger app, widget, and route lifecycle events:'),
            const SizedBox(height: 8),
            const Text('Configured tag: [AppLifecycle]'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _toggleProbe,
                  child: Text(_showProbe ? 'Dispose probe' : 'Create probe'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        settings: const RouteSettings(name: '/details'),
                        builder: (_) => const _DetailsPage(),
                      ),
                    );
                  },
                  child: const Text('Push details page'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_showProbe) const _LifecycleProbe(),
            const SizedBox(height: 16),
            const Text('Recent lifecycle events:'),
            const SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder<List<LifecycleEvent>>(
                valueListenable: _eventsNotifier,
                builder: (_, events, __) {
                  if (events.isEmpty) {
                    return const Text('No events yet.');
                  }
                  return ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (_, index) {
                      final event = events[index];
                      return Text(
                        '${event.timestamp.toIso8601String()} - ${event.type.name} - ${event.message}',
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Pop back'),
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
    debugPrint('[AppLifecycle] _LifecycleProbe onInit hook fired');
  }

  @override
  void onDispose() {
    debugPrint('[AppLifecycle] _LifecycleProbe onDispose hook fired');
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Probe mounted (uses LifecycleAware)');
  }
}
