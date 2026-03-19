import 'dart:async';

import 'package:flutter/foundation.dart';

import 'lifecycle_event.dart';

typedef LifecycleEventSink = void Function(LifecycleEvent event);
typedef LifecycleEventFilter = bool Function(LifecycleEvent event);
typedef LifecycleSinkErrorHandler = void Function(
  Object error,
  StackTrace stackTrace,
  LifecycleEvent event,
);

class LifecycleLog {
  LifecycleLog._();

  static const String _defaultTag = '[Lifecycle]';
  static LifecycleEventSink? _sink;
  static LifecycleEventSink? _onEvent;
  static LifecycleEventFilter? _filter;
  static LifecycleSinkErrorHandler? _onSinkError;
  static Map<String, Object?>? _metadata;
  static final ValueNotifier<LifecycleEvent?> _lastEventNotifier =
      ValueNotifier<LifecycleEvent?>(null);
  static final StreamController<LifecycleEvent> _eventController =
      StreamController<LifecycleEvent>.broadcast();
  static bool _logToConsole = true;
  static String _tag = _defaultTag;

  static ValueListenable<LifecycleEvent?> get eventListenable =>
      _lastEventNotifier;
  static Stream<LifecycleEvent> get eventStream => _eventController.stream;

  static void configure({
    LifecycleEventSink? sink,
    LifecycleEventSink? onEvent,
    LifecycleEventFilter? filter,
    LifecycleSinkErrorHandler? onSinkError,
    Map<String, Object?>? metadata,
    bool? logToConsole,
    String? tag,
  }) {
    _sink = sink;
    _onEvent = onEvent;
    _filter = filter;
    _onSinkError = onSinkError;
    _metadata = metadata;
    if (logToConsole != null) {
      _logToConsole = logToConsole;
    }
    if (tag != null && tag.isNotEmpty) {
      _tag = tag;
    }
  }

  static void reset() {
    _sink = null;
    _onEvent = null;
    _filter = null;
    _onSinkError = null;
    _metadata = null;
    _logToConsole = true;
    _tag = _defaultTag;
    _lastEventNotifier.value = null;
  }

  static void emit(LifecycleEvent event) {
    final enrichedEvent = _withMetadata(event);

    if (!(_filter?.call(enrichedEvent) ?? true)) {
      return;
    }

    if (_logToConsole) {
      debugPrint('$_tag ${enrichedEvent.message}');
    }

    _lastEventNotifier.value = enrichedEvent;
    _eventController.add(enrichedEvent);

    _safeDeliver(_onEvent, enrichedEvent);
    _safeDeliver(_sink, enrichedEvent);
  }

  static LifecycleEvent _withMetadata(LifecycleEvent event) {
    if (_metadata == null || _metadata!.isEmpty) {
      return event;
    }

    final mergedMetadata = <String, Object?>{..._metadata!};
    if (event.metadata != null) {
      mergedMetadata.addAll(event.metadata!);
    }

    return event.copyWith(metadata: mergedMetadata);
  }

  static void _safeDeliver(LifecycleEventSink? sink, LifecycleEvent event) {
    if (sink == null) {
      return;
    }

    try {
      sink(event);
    } catch (error, stackTrace) {
      _onSinkError?.call(error, stackTrace, event);
    }
  }
}
