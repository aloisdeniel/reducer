import '../lib/counter.dart';

void main() {
  var state = CounterState(0);
  const reducer = CounterReducer();
  state = reducer(state, const CounterAddAction(value: 5));
  state = reducer(state, const CounterResetAction());
}
