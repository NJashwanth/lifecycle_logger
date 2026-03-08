# lifecycle_logger example

Minimal example app for validating the `lifecycle_logger` package.

## What it demonstrates

- `LifecycleLogger.attach()` in `main()`
- Custom console tag via `LifecycleLogger.attach(tag: '[AppLifecycle]')`
- App lifecycle callbacks (`onResume`, `onPause`, `onInactive`, `onDetached`)
- `LifecycleAware` mixin behavior for widget `initState` and `dispose`

## Run

```bash
flutter pub get
flutter run
```

Then use the buttons in the app to generate widget and route events and watch
the debug console for `[AppLifecycle]` log entries.
