# lifecycle_logger

A debug-focused, zero-UI Flutter utility package for app and widget lifecycle logging.

## Features

- App lifecycle observer via `WidgetsBindingObserver`
- Widget lifecycle logging mixin for `initState` and `dispose`
- Debug-only by default (`attach(debugOnly: true)`)
- Minimal API, no dependencies beyond Flutter SDK

## Debug-only behavior

By default, `LifecycleLogger.attach()` runs with `debugOnly: true`.

- In debug mode: observer registration, logs, and callbacks run normally.
- In profile/release mode: `attach()` becomes a no-op.

If you need lifecycle callbacks outside debug (for local testing), pass `debugOnly: false`.

## Usage

```dart
import 'package:flutter/widgets.dart';
import 'package:lifecycle_logger/lifecycle_logger.dart';

void main() {
	WidgetsFlutterBinding.ensureInitialized();

	LifecycleLogger.attach(
		onResume: () => debugPrint('resumed callback'),
		onPause: () => debugPrint('paused callback'),
	);

	runApp(const App());
}
```

When no longer needed, unregister safely:

```dart
LifecycleLogger.detach();
```

### Widget lifecycle mixin

```dart
class MyWidget extends StatefulWidget {
	const MyWidget({super.key});

	@override
	State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with LifecycleAware<MyWidget> {
	@override
	void onInit() {
		// Custom init hook
	}

	@override
	void onDispose() {
		// Custom dispose hook
	}

	@override
	Widget build(BuildContext context) {
		return const SizedBox.shrink();
	}
}
```

## Log format

- `[Lifecycle] App resumed`
- `[Lifecycle] App paused`
- `[Lifecycle] MyWidget initState`
- `[Lifecycle] MyWidget dispose`

