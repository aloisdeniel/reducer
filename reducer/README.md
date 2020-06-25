Generates actions and a reducer from a set of pure functions.

## Install

To use [built_reducer], you will need your typical [build_runner]/code-generator setup.\
First, install [build_runner] and [built_reducer] by adding them to your `pubspec.yaml` file:

```yaml
# pubspec.yaml
dependencies:
  reducer:

dev_dependencies:
  build_runner:
  built_reducer:
```

This install three packages:

- build_runner, the tool to run code-generators
- [built_reducer], the code generator
- reducer, a package containing base types for [built_reducer].

## Usage

```dart
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
```

From there, to run the code generator, you have two possibilities:

- `flutter pub run build_runner build`, if your package depends on Flutter
- `pub run build_runner build` otherwise

Then use the reducer from the actions :

```dart
var state = CounterState(0);
const reducer = CounterReducer();
state = reducer(state, const CounterAddAction(value: 5));
state = reducer(state, const CounterResetAction());
```

## Resulting file

You have a result in the [example folder](example/lib/counter.g.dart).

## Why using a reducer instead of methods directly.

Since each call is represented with an instance, you have more possibilities :

* Reproducing a sequence of calls.
* Adding middlewares
* Serializing calls
* Redux

