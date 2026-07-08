import 'dart:async';

import 'app_event.dart';

/// App-wide domain event bus. Register as a lazy singleton in DI.
///
/// Publish: `getIt<EventBus>().fire(const GroupCreated(...))`
/// Subscribe: `getIt<EventBus>().on<MatchApproved>().listen((e) => ...)`
class EventBus {
  final _controller = StreamController<AppEvent>.broadcast();

  void fire(final AppEvent event) => _controller.add(event);

  Stream<T> on<T extends AppEvent>() =>
      _controller.stream.where((final e) => e is T).cast<T>();

  Future<void> dispose() => _controller.close();
}
