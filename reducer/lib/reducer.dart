library reducer;

import 'package:meta/meta.dart';

@immutable
abstract class Reducer<TState, TAction> {
  const Reducer();

  /// Reduces the [previousState] into a new state, from the given
  /// the [action].
  TState call(TState previousState, TAction action);

  /// Indicates whether this reducer can process this
  /// kind of action.
  bool operator [](Type actionType);
}
