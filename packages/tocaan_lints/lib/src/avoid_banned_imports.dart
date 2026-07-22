import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Resolves an import's target path relative to the file that imports it.
///
/// Handles relative imports (`../features/x.dart`) and `package:` imports
/// that point back into this app's own `lib/` (`package:app/features/x.dart`).
String? _resolveImportTarget(String importingFilePath, String importUri) {
  if (importUri.startsWith('dart:')) return null;

  if (importUri.startsWith('package:')) {
    final withoutScheme = importUri.substring('package:'.length);
    final slashIndex = withoutScheme.indexOf('/');
    if (slashIndex == -1) return null;
    return withoutScheme.substring(slashIndex + 1);
  }

  // Relative import: resolve it against the importing file's lib-relative path.
  final normalizedFile = importingFilePath.replaceAll(r'\', '/');
  final libIndex = normalizedFile.lastIndexOf('/lib/');
  if (libIndex == -1) return null;

  final fileLibRelative = normalizedFile.substring(libIndex + '/lib/'.length);
  final fileSegments = fileLibRelative.split('/')..removeLast();

  for (final segment in importUri.split('/')) {
    if (segment == '.') continue;
    if (segment == '..') {
      if (fileSegments.isNotEmpty) fileSegments.removeLast();
    } else {
      fileSegments.add(segment);
    }
  }
  return fileSegments.join('/');
}

bool _isUnderLibPath(String filePath, String pattern) {
  final normalized = filePath.replaceAll(r'\', '/');
  final libIndex = normalized.lastIndexOf('/lib/');
  if (libIndex == -1) return false;
  final libRelative = normalized.substring(libIndex + '/lib/'.length);
  return libRelative.startsWith(pattern);
}

class CoreImportsFeatures extends DartLintRule {
  const CoreImportsFeatures() : super(code: _code);

  static const _code = LintCode(
    name: 'core_imports_features',
    problemMessage: 'Core layer should not depend on Features.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!_isUnderLibPath(resolver.path, 'core/')) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      final target = _resolveImportTarget(resolver.path, uri);
      if (target != null && target.startsWith('features/')) {
        reporter.atNode(node, _code);
      }
    });
  }
}

class WidgetsImportsFeatures extends DartLintRule {
  const WidgetsImportsFeatures() : super(code: _code);

  static const _code = LintCode(
    name: 'widgets_imports_features',
    problemMessage: 'Widgets should not depend on Features.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!_isUnderLibPath(resolver.path, 'widgets/')) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      final target = _resolveImportTarget(resolver.path, uri);
      if (target != null && target.startsWith('features/')) {
        reporter.atNode(node, _code);
      }
    });
  }
}

class CoreDataLayerImportsWidgets extends DartLintRule {
  const CoreDataLayerImportsWidgets() : super(code: _code);

  static const _code = LintCode(
    name: 'core_data_layer_imports_widgets',
    problemMessage: 'Core data layer should not depend on Widgets.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  static const _guardedPaths = [
    'core/models/',
    'core/enums/',
    'core/datasources/',
    'core/network_utils/',
  ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final inGuardedPath = _guardedPaths.any(
      (path) => _isUnderLibPath(resolver.path, path),
    );
    if (!inGuardedPath) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      final target = _resolveImportTarget(resolver.path, uri);
      if (target != null && target.startsWith('widgets/')) {
        reporter.atNode(node, _code);
      }
    });
  }
}
