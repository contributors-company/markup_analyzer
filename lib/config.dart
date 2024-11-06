import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _defaultSimple = true;
const _defaultInterpolation = true;
const _defaultBinary = true;
const _defaultAdjacent = true;
const _defaultPrefixedIdentifier = false;
const _defaultMethod = false;
const _defaultSimpleIdentifier = false;
const _defaultProperty = false;
const _defaultFunction = false;

extension ErrorSeverityExt on ErrorSeverity {
  static ErrorSeverity fromString(String? value) {
    return switch (value) {
      'error' => ErrorSeverity.ERROR,
      'info' => ErrorSeverity.INFO,
      'warning' => ErrorSeverity.WARNING,
      String() => ErrorSeverity.ERROR,
      null => ErrorSeverity.ERROR,
    };
  }
}

class Config {
  Config({
    this.simple = _defaultSimple,
    this.prefixedIdentifier = _defaultPrefixedIdentifier,
    this.interpolation = _defaultInterpolation,
    this.binary = _defaultBinary,
    this.adjacent = _defaultAdjacent,
    this.method = _defaultMethod,
    this.simpleIdentifier = _defaultSimpleIdentifier,
    this.property = _defaultProperty,
    this.function = _defaultFunction,
    this.severity = ErrorSeverity.ERROR,
  });

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      simple: map['simple'] ?? _defaultSimple,
      prefixedIdentifier:
      map['prefixed_identifier'] ?? _defaultPrefixedIdentifier,
      interpolation: map['interpolation'] ?? _defaultInterpolation,
      binary: map['binary'] ?? _defaultBinary,
      adjacent: map['adjacent'] ?? _defaultAdjacent,
      method: map['method'] ?? _defaultMethod,
      simpleIdentifier: map['simple_identifier'] ?? _defaultSimpleIdentifier,
      property: map['property'] ?? _defaultProperty,
      function: map['function'] ?? _defaultFunction,
      severity: ErrorSeverityExt.fromString(map['severity']),
    );
  }

  factory Config.fromRules(Map<String, LintOptions> rules) {
    if (rules.isEmpty) {
      return Config();
    }

    try {
      return Config.fromMap(
        rules.entries.first.value.json,
      );
    } catch (error, stackTrace) {
      stdout.write(error);
      stdout.write(stackTrace);
      return Config();
    }
  }


  final bool simple;
  final bool prefixedIdentifier;
  final bool interpolation;
  final bool binary;
  final bool adjacent;
  final bool method;
  final bool simpleIdentifier;
  final bool property;
  final bool function;
  final ErrorSeverity severity;
}
