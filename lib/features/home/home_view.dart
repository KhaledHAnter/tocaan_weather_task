import 'package:flutter/material.dart';

import '../../core/helpers/app_colors.dart';
import '../../widgets/app_text.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const AppText(
          title: 'Weather',
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: const Center(child: AppText(title: 'Weather app coming soon')),
    );
  }
}
