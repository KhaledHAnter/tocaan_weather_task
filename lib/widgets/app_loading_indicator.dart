import 'package:flutter/material.dart';

import '../core/helpers/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.color = AppColors.primary,
    this.strokeWidth = 2.5,
    this.padding = EdgeInsets.zero,
    this.unconstrained = true,
  });

  final double size;
  final Color color;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;
  final bool unconstrained;

  @override
  Widget build(BuildContext context) {
    final indicator = Padding(
      padding: padding,
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
    if (!unconstrained) return indicator;
    return UnconstrainedBox(child: indicator);
  }
}
