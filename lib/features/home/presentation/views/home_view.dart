import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/app_colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..init(query: 'jdskdslksjckl'),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

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
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          return switch (state) {
            HomeInit() || HomeLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            HomeLoaded(:final weather) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    title: weather.location?.name ?? '',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  AppText(
                    title: '${weather.current?.tempC?.round() ?? '--'}°C',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(title: weather.current?.condition?.text ?? ''),
                ],
              ),
            ),
            HomeError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      title: message,
                      textAlign: TextAlign.center,
                      color: AppColors.red,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      title: 'Retry',
                      onTap: () =>
                          context.read<HomeCubit>().init(query: 'egypt'),
                    ),
                  ],
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
