library reducer;

import 'package:meta/meta.dart';

@immutable
abstract class Reducer<TState, TAction> {
  const Reducer();

  /// Reduces the [previousState] into a new state, from the given
  /// the [action].
  TState call(TState previousState, TAction action);

  /// Indicates whether this reducer may process this
  /// kind of [action].
  ///
  /// The [action] may be an instance or the action [Type].
  bool operator [](Object action);
}
