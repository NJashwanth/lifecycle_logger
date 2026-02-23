import 'package:flutter_test/flutter_test.dart';

import 'package:lifecycle_logger_example/main.dart';

void main() {
  testWidgets('example mounts and toggles lifecycle probe', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());

    expect(
      find.text('Watch debug console for lifecycle logs.'),
      findsOneWidget,
    );
    expect(find.text('Probe mounted (uses LifecycleAware)'), findsOneWidget);
    expect(find.text('Dispose probe'), findsOneWidget);

    await tester.tap(find.text('Dispose probe'));
    await tester.pumpAndSettle();
    expect(find.text('Probe mounted (uses LifecycleAware)'), findsNothing);
    expect(find.text('Create probe'), findsOneWidget);

    await tester.tap(find.text('Create probe'));
    await tester.pumpAndSettle();
    expect(find.text('Probe mounted (uses LifecycleAware)'), findsOneWidget);
    expect(find.text('Dispose probe'), findsOneWidget);
  });
}
