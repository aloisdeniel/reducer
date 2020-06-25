import 'package:recase/recase.dart';

String baseName(String reducerName) => reducerName.replaceAll('Reducer', '');

String mixinName(String reducerName) => '_' + reducerName;

String baseActionName(String reducerName) => baseName(reducerName) + 'Action';

String actionName(String reducerName, String methodName) =>
    baseName(reducerName) + ReCase(methodName).pascalCase + 'Action';
