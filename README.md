# Test Localization Checker

## Description

This tool checks if there are any untranslated strings in your presentation layer.

### Installing dependencies

```bash
dart pub get test_localization
```

## Create configuration file

Create a `test_localization.yaml` file in the root of your project with the following content:

```yaml
# The path to the directory checking
output: lib/presentation
```

## Usage

Run the script with the following command:

```bash
dart run test_localization
```

## Options

- `-h, --help`: Output usage information.
- `--version`: Output the version of the tool.
