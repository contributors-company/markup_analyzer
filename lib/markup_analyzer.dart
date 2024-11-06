import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _RestrictiveLinter();

class _RestrictiveLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    ProhibitAllVariables(),
    ProhibitAllFunctions(),
    ProhibitAllClasses(),
  ];
}

class ProhibitAllVariables extends DartLintRule {
  ProhibitAllVariables()
      : super(
    code: LintCode(
      name: 'prohibit_all_variables',
      problemMessage: 'Variable declarations are not allowed.',
    ),
  );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {
    context.registry.addVariableDeclaration((node) {
      reporter.atNode(node, code);
    });
  }
}

class ProhibitAllFunctions extends DartLintRule {
  ProhibitAllFunctions()
      : super(
    code: LintCode(
      name: 'prohibit_all_functions',
      problemMessage: 'Function declarations are not allowed.',
    ),
  );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {
    context.registry.addFunctionDeclaration((node) {
      reporter.atNode(node, code);
    });
  }
}

class ProhibitAllClasses extends DartLintRule {
  ProhibitAllClasses()
      : super(
    code: LintCode(
      name: 'prohibit_all_classes',
      problemMessage: 'Class declarations are not allowed.',
    ),
  );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {
    context.registry.addClassDeclaration((node) {
      reporter.atNode(node, code);
    });
  }
}
