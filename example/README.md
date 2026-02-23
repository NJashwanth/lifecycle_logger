# lifecycle_logger example

Minimal example app for validating the `lifecycle_logger` package.

## What it demonstrates

- `LifecycleLogger.attach()` in `main()`
- App lifecycle callbacks (`onResume`, `onPause`, `onInactive`, `onDetached`)
- `LifecycleAware` mixin behavior for widget `initState` and `dispose`

## Run

```bash
flutter pub get
flutter run
```

Then use the button in the app to dispose/recreate the probe widget and watch
the debug console for `[Lifecycle]` log entries.
