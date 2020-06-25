import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:reducer/reducer.dart';
import 'package:source_gen/source_gen.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'names.dart';

class ReducerGenerator extends Generator {
  final bool forClasses;

  const ReducerGenerator({
    this.forClasses = true,
  });

  @override
  Future<String> generate(LibraryReader library, _) async {
    var output = StringBuffer();
    final typeChecker = const TypeChecker.fromRuntime(Reducer);
    final reducers = library.classes
        .where((x) =>
            x.allSupertypes.isNotEmpty &&
            x.allSupertypes.any((x) => typeChecker.isExactlyType(x)))
        .toList();

    final classes = <Class>[];

    for (var reducer in reducers) {
      final reducerSupertype =
          reducer.allSupertypes.firstWhere((x) => typeChecker.isExactlyType(x));
      final stateClass = reducerSupertype.typeArguments.first;
      final mixinGenerator = ReducerMixinGenerator(
        reducerClass: reducer,
        stateClass: stateClass,
      );
      output.writeln(DartFormatter().format(mixinGenerator.build()));

      final baseActionGenerator = ReducerBaseActionGenerator(
        reducerClass: reducer,
      );
      classes.add(baseActionGenerator.build());

      for (var method in mixinGenerator.actionMethods) {
        final actionGenerator = ReducerActionGenerator(
          reducerClass: reducer,
          actionMethod: method,
        );
        classes.add(actionGenerator.build());
      }
    }

    // Outputs code for each method

    final emitter = DartEmitter();
    classes.forEach((c) {
      output.writeln(DartFormatter().format('${c.accept(emitter)}'));
    });
    return '$output';
  }

  @override
  String toString() => 'ReducerGenerator';
}

class ReducerMixinGenerator {
  final ClassElement reducerClass;
  final DartType stateClass;

  ReducerMixinGenerator({
    @required this.reducerClass,
    @required this.stateClass,
  });

  List<MethodElement> get actionMethods {
    final typeChecker = TypeChecker.fromStatic(stateClass);
    return reducerClass.methods
        .where((x) => x.isStatic)
        .where(
          (x) =>
              x.parameters.isNotEmpty &&
              typeChecker.isExactlyType(x.parameters.first.type),
        )
        .toList();
  }

  String build() {
    final typeName = mixinName(reducerClass.name);
    final baseAction = baseActionName(reducerClass.name);
    final actionMethods = this.actionMethods;
    final actionNames = actionMethods
        .map((x) => actionName(reducerClass.name, x.name))
        .map((x) => '$x,')
        .join();

    final actionCases = actionMethods.map((x) {
      final name = actionName(reducerClass.name, x.name);
      final parameters = x.parameters
          .skip(1)
          .map((p) => '${p.isNamed ? p.name + ':' : ''} action.${p.name},')
          .join();
      return '''
      if(action is $name) {
        return ${reducerClass.name}.${x.name}(previousState, $parameters);
      }
      ''';
    }).join();

    return '''
  mixin $typeName {
    ${stateClass.getDisplayString()} call(${stateClass.getDisplayString()} previousState, $baseAction action) {
      $actionCases
      return previousState;
    }

    bool operator [](Type actionType) {
      return const [
        ${actionNames}
      ].contains(actionType);
    }
  }''';
  }
}

class ReducerBaseActionGenerator {
  final ClassElement reducerClass;

  ReducerBaseActionGenerator({
    @required this.reducerClass,
  });

  Class build() {
    final builder = ClassBuilder()
      ..name = baseActionName(reducerClass.name)
      ..abstract = true;

    final constructor = ConstructorBuilder()..constant = true;
    builder.constructors.add(constructor.build());

    return builder.build();
  }
}

class ReducerActionGenerator {
  final ClassElement reducerClass;
  final MethodElement actionMethod;

  ReducerActionGenerator({
    @required this.reducerClass,
    @required this.actionMethod,
  });

  Class build() {
    final builder = ClassBuilder()
      ..name = actionName(reducerClass.name, actionMethod.name)
      ..extend = refer(baseActionName(reducerClass.name));

    final parameters = actionMethod.parameters.skip(1);

    builder.fields.addAll(parameters.map(
      (x) => Field(
        (b) => b
          ..name = x.name
          ..modifier = FieldModifier.final$
          ..type = refer(x.type.getDisplayString()),
      ),
    ));

    final constructor = ConstructorBuilder()
      ..constant = true
      ..optionalParameters.addAll(
        parameters.map(
          (x) => Parameter(
            (b) => b
              ..named = true
              ..name = 'this.' + x.name
              ..annotations.addAll([
                if (x.hasRequired) CodeExpression(Code('required')),
              ]),
          ),
        ),
      );

    builder.constructors.add(constructor.build());

    return builder.build();
  }
}
