import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/avoid_banned_imports.dart';

PluginBase createPlugin() => _TocaanLints();

class _TocaanLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    const CoreImportsFeatures(),
    const WidgetsImportsFeatures(),
    const CoreDataLayerImportsWidgets(),
  ];
}
