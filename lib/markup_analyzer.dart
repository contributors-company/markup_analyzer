import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'config.dart';

PluginBase createPlugin() => _MarkupLinter();

class _MarkupLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final config = Config.fromRules(configs.rules);
    return [
      ProhibitAllClasses(config),
    ];
  }
}

class ProhibitAllClasses extends DartLintRule {
  final Config config;
  ProhibitAllClasses(this.config)
      : super(
          code: LintCode(name: '', problemMessage: ''),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addArgumentList((ArgumentList argumentList) {
      if (argumentList.parent case InstanceCreationExpression object) {
        final superTypes =
            object.constructorName.staticElement?.returnType.allSupertypes;

        superTypes?.forEach((type) {
          // If not constructor Widget
          if (!_widgetChecker.isExactlyType(type)) return;

          _checkParameters(reporter, argumentList);
        });
      }
    });
  }

  void _checkParameters(ErrorReporter reporter, ArgumentList argumentList) {
    for (var arg in argumentList.arguments) {
      final argStaticType = arg.staticType;
      if (argStaticType == null) return;

      // If not String parameter
      if (!_stringChecker.isExactlyType(argStaticType)) return;

      if (_checkValue(arg) case LintCode code) reporter.atNode(arg, code);
    }
  }

  LintCode? _checkValue(Expression arg) {
    return switch (arg) {
      SimpleStringLiteral() when config.simple => LintCode(
          name: 'simple_string',
          problemMessage: 'Simple string literal is not allowed.',
          errorSeverity: config.severity,
        ),
      PrefixedIdentifier() when config.prefixedIdentifier => LintCode(
          name: 'prefixed_identifier',
          problemMessage: 'Prefixed identifier is not allowed.',
          errorSeverity: config.severity),
      StringInterpolation() when config.interpolation => LintCode(
          name: 'string_interpolation',
          problemMessage: 'String interpolation is not allowed.',
          errorSeverity: config.severity,
        ),
      BinaryExpression() when config.binary => LintCode(
          name: 'binary_expression',
          problemMessage: 'Binary expression is not allowed.',
          errorSeverity: config.severity,
        ),
      AdjacentStrings() when config.adjacent => LintCode(
          name: 'adjacent_strings',
          problemMessage: 'Adjacent strings are not allowed.',
          errorSeverity: config.severity,
        ),
      MethodInvocation() when config.method => LintCode(
          name: 'method_invocation',
          problemMessage: 'Method invocation is not allowed.',
          errorSeverity: config.severity,
        ),
      SimpleIdentifier() when config.simpleIdentifier => LintCode(
          name: 'simple_identifier',
          problemMessage: 'Simple identifier is not allowed.',
          errorSeverity: config.severity,
        ),
      FunctionExpressionInvocation() when config.function => LintCode(
          name: 'function_invocation',
          problemMessage: 'Function expression invocation is not allowed.',
          errorSeverity: config.severity,
        ),
      PropertyAccess() when config.property => LintCode(
          name: 'property_access',
          problemMessage: 'Property access is not allowed.',
          errorSeverity: config.severity,
        ),
      NamedExpression(:Expression expression) =>
        _checkValue(expression), // Рекурсивная обработка именованного выражения

      _ => null
    };
  }

  static const TypeChecker _widgetChecker = TypeChecker.fromName(
    "Widget",
  );

  static const TypeChecker _stringChecker = TypeChecker.fromName(
    "String",
  );
}
