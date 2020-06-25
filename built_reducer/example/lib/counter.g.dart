// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// ReducerGenerator
// **************************************************************************

mixin _CounterReducer {
  CounterState call(CounterState previousState, CounterAction action) {
    if (action is CounterAddAction) {
      return CounterReducer.add(
        previousState,
        value: action.value,
      );
    }
    if (action is CounterResetAction) {
      return CounterReducer.reset(
        previousState,
      );
    }

    return previousState;
  }

  bool operator [](Type actionType) {
    return const [
      CounterAddAction,
      CounterResetAction,
    ].contains(actionType);
  }
}

abstract class CounterAction {}

class CounterAddAction extends CounterAction {
  CounterAddAction({@required this.value});

  final int value;
}

class CounterResetAction extends CounterAction {
  CounterResetAction();
}
