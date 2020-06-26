// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// ReducerGenerator
// **************************************************************************

mixin _CounterReducer {
  CounterState call(CounterState previousState, CounterAction action) {
    final reducer = this as CounterReducer;
    if (action is CounterAddAction) {
      return reducer.add(
        previousState,
        value: action.value,
      );
    }
    if (action is CounterResetAction) {
      return reducer.reset(
        previousState,
      );
    }

    return previousState;
  }

  bool operator [](Object action) {
    final actionType = action is Type ? action : action.runtimeType;
    return const [
      CounterAddAction,
      CounterResetAction,
    ].contains(actionType);
  }
}

abstract class CounterAction {
  const CounterAction();
}

class CounterAddAction extends CounterAction {
  const CounterAddAction({@required this.value});

  final int value;
}

class CounterResetAction extends CounterAction {
  const CounterResetAction();
}
