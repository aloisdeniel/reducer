import 'package:meta/meta.dart';
import 'package:reducer/reducer.dart';

part 'counter.g.dart';

@immutable
class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterReducer extends Reducer<CounterState, CounterAction>
    with _CounterReducer {
  const CounterReducer();

  CounterState add(CounterState previousState, {@required int value}) {
    return CounterState(previousState.count + value);
  }

  CounterState reset(CounterState previousState) {
    return CounterState(0);
  }
}
