## 0.0.2

* Reduced minimum Flutter SDK requirement to `>=3.0.0`.
* Updated compatibility handling for lifecycle enum values on older Flutter versions.

## 0.0.1

* Initial release of `lifecycle_logger`.
* Added `LifecycleLogger.attach()` and `LifecycleLogger.detach()` for app lifecycle observation.
* Added `LifecycleAware` mixin for widget `initState` and `dispose` logging with hooks.
* Added internal centralized logger with `[Lifecycle]` prefix.
* Added minimal example app and behavior tests.
