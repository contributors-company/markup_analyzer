import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

const String version = '0.0.1';
const String flavorConfigFilePattern = r'^test_localization.yaml$';

const String helpFlag = 'help';
const String versionFlag = 'version';

String? getFlavors() {
  for (var item in Directory('.').listSync()) {
    if (item is File) {
      final name = path.basename(item.path);
      final match = RegExp(flavorConfigFilePattern).firstMatch(name);
      if (match != null) {
        return name;
      }
    }
  }
  return null;
}

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      helpFlag,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      versionFlag,
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart run test_localization');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('test_localization version: $version');
      return;
    }
    if (results.arguments.isEmpty) {
      check();
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

check() {
  final flavors = getFlavors();
  if (flavors == null) {
    throw FormatException('No configuration file found.');
  }
  final File pubspec = File(flavors);
  final String pubspecContent = pubspec.readAsStringSync();

  final Map yamlMap = loadYaml(pubspecContent);
  String output = yamlMap['output'];
  int countFiles = 0;
  int countErrors = 0;
  [countFiles, countErrors] =
      workWithDirectory(output, countFiles, countErrors);

  if (countErrors == 0) {
    print('No errors found');
  } else {
    print('Found $countErrors errors in $countFiles files');
  }
}

List workWithDirectory(String output, int countFiles, int countErrors) {
  Directory(output).listSync().forEach((file) async {
    if (file is File) {
      final initialErrors = countErrors;
      final content = file.readAsStringSync();

      final buildMethod =
          RegExp(r'Widget build\(BuildContext context\) {([\s\S]*?)}')
              .allMatches(content);
      for (var element in buildMethod) {
        String? buildContent = element.group(0);
        if (buildContent == null) {
          continue;
        }
        final strings = RegExp(r"('(.*?)'|`(.*?)`)").allMatches(buildContent);
        for (var e in strings) {
          final string = e.group(0);
          if (string == null || string.isEmpty) {
            continue;
          }
          RegExpMatch? match =
              RegExp(r'\$[a-zA-Z_][a-zA-Z0-9_]*|\$\{[a-zA-Z_][a-zA-Z0-9_]*\}')
                  .firstMatch(string);
          if (match == null) {
            if (initialErrors == countErrors) {
              countFiles++;
            }
            stdout
              ..writeln(file.path)
              ..writeln(' $string • error')
              ..writeln();
            countErrors++;
          }
        }
      }
    }
    if (file is Directory) {
      [countFiles, countErrors] =
          workWithDirectory(file.path, countFiles, countErrors);
    }
  });
  return [countFiles, countErrors];
}
