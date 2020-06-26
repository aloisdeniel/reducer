import 'package:meta/meta.dart';
import 'package:reducer/reducer.dart';

void main() {
  var state = CounterState(0);
  const reducer = CounterReducer();
  state = reducer(state, const CounterAddAction(value: 5));
  state = reducer(state, const CounterResetAction());
}

@immutable
class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterReducer extends Reducer<CounterState, CounterAction>
    with _CounterReducer {
  const CounterReducer();
  CounterState add(CounterState previousState, {int value}) {
    return CounterState(previousState.count + value);
  }

  CounterState reset(CounterState previousState) {
    return CounterState(0);
  }
}

/** The following can be generated */

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
  final int value;
  const CounterAddAction({
    this.value,
  });
}

class CounterResetAction extends CounterAction {
  const CounterResetAction();
}
