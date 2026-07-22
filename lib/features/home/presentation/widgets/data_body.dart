part of '../views/home_view.dart';

class _DataBody extends StatelessWidget {
  const _DataBody();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.of(context);
    final weather = cubit.weather;
    final isLoading = cubit.isLoading || cubit.isSearching;
    return Column(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  title: weather?.location?.name ?? '',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  title: '${weather?.current?.tempC?.round() ?? '--'}°C',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
                AppText(
                  title: weather?.current?.condition?.text ?? '',
                  color: context.colors.muted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
