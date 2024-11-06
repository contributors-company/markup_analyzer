# MarkupAnalyzer Lint Rule

## Description

`MarkupAnalyzer` is a customizable lint rule for the [`custom_lint`](https://pub.dev/packages/custom_lint) package in Dart/Flutter. It allows you to prohibit specific types of string expressions in the parameters of Flutter widgets.

This rule enables you to control the usage of string expressions such as simple string literals, interpolations, binary expressions, and others based on your configuration.


- [MarkupAnalyzer Lint Rule](#markupanalyzer-lint-rule)
  - [Description](#description)
  - [Installation](#installation)
  - [Configuration](#configuration)
    - [Configuration Parameters:](#configuration-parameters)
  - [Usage](#usage)
  - [Examples](#examples)
    - [1. Simple String Literals (`simple`)](#1-simple-string-literals-simple)
    - [2. Prefixed Identifiers (`prefixed_identifier`)](#2-prefixed-identifiers-prefixed_identifier)
    - [3. String Interpolation (`interpolation`)](#3-string-interpolation-interpolation)
    - [4. Binary Expressions (`binary`)](#4-binary-expressions-binary)
    - [5. Adjacent Strings (`adjacent`)](#5-adjacent-strings-adjacent)
    - [6. Method Invocations (`method`)](#6-method-invocations-method)
    - [7. Simple Identifiers (`simple_identifier`)](#7-simple-identifiers-simple_identifier)
    - [8. Property Access (`property`)](#8-property-access-property)
    - [9. Function Invocations (`function`)](#9-function-invocations-function)

## Installation

1. **Add the package to your project's dependencies:**

   Add the following to your project's `pubspec.yaml` under `dev_dependencies`:

   ```yaml
   dev_dependencies:
     custom_lint: 
     markup_analyzer: ^latest_version
   ```

2. **Get the dependencies:**

   ```bash
   flutter pub get
   ```

3. **Activate the plugin in `analysis_options.yaml`:**

   Create or update the `analysis_options.yaml` file at the root of your project:

   ```yaml
   analyzer:
     plugins:
       - custom_lint

   custom_lint:
     rules:
       - markup_analyzer
   ```

## Configuration

You can configure the `MarkupAnalyzer` rule via `analysis_options.yaml` by specifying which types of string expressions should be prohibited and the severity level of the error.

Example of a full configuration:

```yaml
custom_lint:
  rules:
    markup_analyzer:
      simple: true
      prefixed_identifier: false
      interpolation: true
      binary: true
      adjacent: true
      method: false
      simple_identifier: false
      property: false
      function: false
      severity: error  # Possible values: error, warning, info
```

### Configuration Parameters:

- `**simple**`: Prohibits the use of simple string literals.

- `**prefixed_identifier**`: Prohibits the use of prefixed identifiers (e.g., `widget.title`).

- `**interpolation**`: Prohibits the use of string interpolation (e.g., `'Hello, $name'`).

- `**binary**`: Prohibits the use of binary expressions with the `+` operator for string concatenation.

- `**adjacent**`: Prohibits the use of adjacent string literals (e.g., `'Hello, ''world'`).

- `**method**`: Prohibits method invocations that return a string (e.g., `'Hello'.toUpperCase()`).

- `**simple_identifier**`: Prohibits the use of simple identifiers (e.g., variables like `title`).

- `**property**`: Prohibits accessing object properties that return a string (e.g., `object.property`).

- `**function**`: Prohibits function invocations that return a string (e.g., `getString()`).

- `**severity**`: The severity level of the error. Possible values: `error`, `warning`, `info`.

## Usage

After setting up the plugin and configuring the rules, run the analyzer on your project:

```bash
dart run custom_lint
```

All rule violations will be displayed in the console and highlighted in your IDE if it supports `custom_lint`.


## Examples

### 1. Simple String Literals (`simple`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      simple: true
  ```

  ```dart
  // BAD
  Text('Hello, world!'); // Simple string literal is prohibited.

  // GOOD
  final greeting = 'Hello, world!';
  Text(greeting); // Using a variable instead of a literal.
  ```

### 2. Prefixed Identifiers (`prefixed_identifier`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      prefixed_identifier: true
  ```

  ```dart
  // BAD
  Text(widget.title); // Prefixed identifier is prohibited.

  // GOOD
  final title = widget.title;
  Text(title); // Assign to a local variable first.
  ```

### 3. String Interpolation (`interpolation`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      interpolation: true
  ```

  ```dart
  // BAD
  Text('Hello, $name!'); // String interpolation is prohibited.

  // GOOD
  Text('Hello, ' + name + '!'); // Use string concatenation instead.
  ```

### 4. Binary Expressions (`binary`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      binary: true
  ```


  ```dart
  // BAD
  Text('Hello, ' + 'world!'); // Binary expression with '+' is prohibited.

  // GOOD
  Text('Hello, world!'); // Use a single string literal.
  ```

### 5. Adjacent Strings (`adjacent`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      adjacent: true
  ```

  ```dart
  // BAD
  Text(
  'Hello, '
  'world!'
  ); // Adjacent strings are prohibited.

  // GOOD
  Text('Hello, world!'); // Combine into a single string.
  ```

### 6. Method Invocations (`method`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      method: true
  ```

  ```dart
  // BAD
  Text('hello'.toUpperCase()); // Method invocation is prohibited.

  // GOOD
  final upperCaseHello = 'hello'.toUpperCase();
  Text(upperCaseHello); // Use a variable that holds the result.
  ```

### 7. Simple Identifiers (`simple_identifier`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      simple_identifier: true
  ```

  ```dart
  // BAD
  Text(title); // Simple identifier is prohibited.

  // GOOD
  Text('Static Title'); // Use a static string literal.
  ```

### 8. Property Access (`property`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      property: true
  ```

  ```dart
  // BAD
  Text(user.name); // Property access is prohibited.

  // GOOD
  final userName = user.name;
  Text(userName); // Assign the property to a variable first.
  ```

### 9. Function Invocations (`function`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      function: true
  ```

  ```dart
  // BAD
  Text(getGreeting()); // Function invocation is prohibited.

  // GOOD
  final greeting = getGreeting();
  Text(greeting); // Use a variable containing the result.
  ```

```

If your configuration has `simple: true`, running the analyzer will produce an error:
