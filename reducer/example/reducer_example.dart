import 'package:reducer/reducer.dart';

void main() {
  var state = CounterState(0);
  const reducer = CounterReducer();
  state = reducer(state, const CounterAddAction(value: 5));
  state = reducer(state, const CounterResetAction());
}

class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterReducer extends Reducer<CounterState, CounterAction>
    with _CounterReducer {
  const CounterReducer();
  static CounterState add(CounterState previousState, {int value}) {
    return CounterState(previousState.count + value);
  }

  static CounterState reset(CounterState previousState) {
    return CounterState(0);
  }
}

/** The following can be generated */

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

abstract class CounterAction {
  const CounterAction();
}

class CounterAddAction extends CounterAction {
  final int value;
  const CounterAddAction({
    this.value,
  });
}

class CounterResetAction extends CounterAction {
  const CounterResetAction();
}
