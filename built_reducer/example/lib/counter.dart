import 'package:meta/meta.dart';
import 'package:reducer/reducer.dart';

part 'counter.g.dart';

class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterReducer extends Reducer<CounterState, CounterAction>
    with _CounterReducer {
  const CounterReducer();

  static CounterState add(CounterState previousState, {@required int value}) {
    return CounterState(previousState.count + value);
  }

  static CounterState reset(CounterState previousState) {
    return CounterState(0);
  }
}
