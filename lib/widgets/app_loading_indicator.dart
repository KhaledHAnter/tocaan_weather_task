import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../core/helpers/app_colors.dart';
import '../core/helpers/dimensions.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size,
    this.color = AppColors.primary,
    this.padding = EdgeInsets.zero,
    this.unconstrained = true,
  });

  final double? size;
  final Color color;
  final EdgeInsetsGeometry padding;
  final bool unconstrained;

  @override
  Widget build(BuildContext context) {
    final indicator = Padding(
      padding: padding,
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color,
        size: size ?? 24.radius,
      ),
    );
    if (!unconstrained) return indicator;
    return UnconstrainedBox(child: indicator);
  }
}
