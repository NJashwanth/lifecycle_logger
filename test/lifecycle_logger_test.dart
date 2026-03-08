import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifecycle_logger/lifecycle_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    LifecycleLogger.detach();
  });

  tearDown(() {
    LifecycleLogger.detach();
  });

  testWidgets('attach registers observer and resume callback fires', (
    tester,
  ) async {
    var resumeCount = 0;

    LifecycleLogger.attach(
      debugOnly: false,
      onResume: () {
        resumeCount++;
      },
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    expect(resumeCount, 1);
  });

  testWidgets('detach unregisters observer', (tester) async {
    var pauseCount = 0;

    LifecycleLogger.attach(
      debugOnly: false,
      onPause: () {
        pauseCount++;
      },
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    expect(pauseCount, 1);

    LifecycleLogger.detach();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    expect(pauseCount, 1);
  });

  testWidgets('attach is safe when called multiple times', (tester) async {
    var resumeCount = 0;

    LifecycleLogger.attach(
      debugOnly: false,
      onResume: () {
        resumeCount++;
      },
    );
    LifecycleLogger.attach(
      debugOnly: false,
      onResume: () {
        resumeCount++;
      },
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    expect(resumeCount, 1);
  });

  testWidgets('detach is safe when called multiple times', (tester) async {
    var inactiveCount = 0;

    LifecycleLogger.attach(
      debugOnly: false,
      onInactive: () {
        inactiveCount++;
      },
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    expect(inactiveCount, 1);

    LifecycleLogger.detach();
    LifecycleLogger.detach();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);

    expect(inactiveCount, 1);
  });

  testWidgets('detach is safe even before attach', (tester) async {
    expect(() => LifecycleLogger.detach(), returnsNormally);
    expect(() => LifecycleLogger.detach(), returnsNormally);
  });

  testWidgets('callbacks fire only for matching lifecycle states', (
    tester,
  ) async {
    var resumeCount = 0;
    var pauseCount = 0;
    var inactiveCount = 0;
    var detachedCount = 0;

    LifecycleLogger.attach(
      debugOnly: false,
      onResume: () {
        resumeCount++;
      },
      onPause: () {
        pauseCount++;
      },
      onInactive: () {
        inactiveCount++;
      },
      onDetached: () {
        detachedCount++;
      },
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);

    expect(resumeCount, 1);
    expect(pauseCount, 1);
    expect(inactiveCount, 1);
    expect(detachedCount, 1);
  });

  testWidgets('sink receives typed lifecycle events', (tester) async {
    final events = <LifecycleEvent>[];

    LifecycleLogger.attach(
      debugOnly: false,
      logToConsole: false,
      sink: events.add,
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    expect(events.length, 2);
    expect(events[0].type, LifecycleEventType.appResumed);
    expect(events[1].type, LifecycleEventType.appPaused);
    expect(events[0].appState, AppLifecycleState.resumed);
    expect(events[1].appState, AppLifecycleState.paused);
  });

  testWidgets('route observer emits route lifecycle events when enabled', (
    tester,
  ) async {
    final events = <LifecycleEvent>[];

    LifecycleLogger.attach(
      debugOnly: false,
      enableRouteObserver: true,
      logToConsole: false,
      sink: events.add,
    );

    final observer = LifecycleLogger.routeObserver as LifecycleRouteObserver;
    final routeA = PageRouteBuilder<void>(
      settings: const RouteSettings(name: '/a'),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
    final routeB = PageRouteBuilder<void>(
      settings: const RouteSettings(name: '/b'),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    );

    observer.didPush(routeA, null);
    observer.didReplace(newRoute: routeB, oldRoute: routeA);
    observer.didPop(routeB, routeA);
    observer.didRemove(routeA, null);

    final eventTypes = events.map((e) => e.type).toList();
    expect(eventTypes, contains(LifecycleEventType.routePush));
    expect(eventTypes, contains(LifecycleEventType.routeReplace));
    expect(eventTypes, contains(LifecycleEventType.routePop));
    expect(eventTypes, contains(LifecycleEventType.routeRemove));
  });

  testWidgets('custom log tag keeps event flow intact', (tester) async {
    final events = <LifecycleEvent>[];

    LifecycleLogger.attach(
      debugOnly: false,
      tag: '[MyLifecycle]',
      logToConsole: false,
      sink: events.add,
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(events.length, 1);
    expect(events.first.type, LifecycleEventType.appResumed);
  });
}
