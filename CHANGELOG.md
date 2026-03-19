## 1.0.0

* Added unified event callback support with `LifecycleLogger.attach(onEvent: ...)`.
* Added broadcast stream API via `LifecycleLogger.events`.
* Added built-in event filtering support (`includeTypes`, `excludeTypes`, route/widget include/exclude filters, and custom `filter`).
* Added app lifecycle transition callback support via `onStateTransition(previous, current, event)`.
* Added sink safety handling with `onSinkError` so sink exceptions do not crash lifecycle delivery.
* Added attach-level metadata enrichment via `metadata`, now available on `LifecycleEvent.metadata`.

## 0.0.4

* Added configurable console log tag via `LifecycleLogger.attach(tag: '...')`.

## 0.0.3

* Added structured `LifecycleEvent` and `LifecycleEventType` models.
* Added configurable event sink support through `LifecycleLogger.attach(sink: ..., logToConsole: ...)`.
* Added optional route lifecycle tracking via `LifecycleLogger.routeObserver` and `enableRouteObserver`.
* Added tests for typed sink events and route observer event emission.

## 0.0.2

* Reduced minimum Flutter SDK requirement to `>=3.0.0`.
* Updated compatibility handling for lifecycle enum values on older Flutter versions.

## 0.0.1

* Initial release of `lifecycle_logger`.
* Added `LifecycleLogger.attach()` and `LifecycleLogger.detach()` for app lifecycle observation.
* Added `LifecycleAware` mixin for widget `initState` and `dispose` logging with hooks.
* Added internal centralized logger with `[Lifecycle]` prefix.
* Added minimal example app and behavior tests.
