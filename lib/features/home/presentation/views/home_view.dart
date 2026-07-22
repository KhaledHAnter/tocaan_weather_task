import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/theme/theme_cubit.dart';
import '../../../../core/helpers/app_colors.dart';
import '../../../../core/helpers/app_theme.dart';
import '../../../../core/helpers/utils.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_loading_indicator.dart';
import '../../../../widgets/app_text.dart';
import '../cubit/home_cubit.dart';

part '../widgets/actions_row.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..init(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: Column(
            children: [
              const _ActionsRow(),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    return switch (state) {
                      HomeInit() || HomeLoading() => const Center(
                        child: AppLoadingIndicator(),
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
                              title:
                                  '${weather.current?.tempC?.round() ?? '--'}°C',
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            ),
                            AppText(
                              title: weather.current?.condition?.text ?? '',
                              color: context.colors.muted,
                            ),
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
                                onTap: () => context.read<HomeCubit>().init(
                                  query: 'egypt',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
