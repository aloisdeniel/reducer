import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';

import 'built_reducer.dart';

Builder built_reducer(BuilderOptions _) =>
    SharedPartBuilder([ReducerGenerator()], 'reducer');
