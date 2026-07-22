part of '../views/home_view.dart';

class _DataBody extends StatelessWidget {
  const _DataBody();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.of(context);
    final weather = cubit.weather;
    final isLoading = cubit.isLoading || cubit.isSearching;
    if (!isLoading && weather == null) {
      return Center(
        child: AppText(
          title: LocaleKeys.search_empty_state.tr(),
          fontSize: 16.font,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: context.colors.skeletonBase,
              highlightColor: context.colors.skeletonHighlight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WeatherConditionIcon(
                  kind: weatherIconKindForCode(
                    weather?.current?.condition?.code,
                  ),
                ),

                SizedBox(height: 4.height),
                AppText(
                  title: weather?.location?.name ?? '',
                  fontSize: 28.font,
                  fontWeight: FontWeight.w600,
                ),

                AppText(
                  title: '${weather?.current?.tempC?.round() ?? '--'}°C',
                  fontSize: 54.font,
                  fontWeight: FontWeight.w700,
                ),
                AppText(
                  title: weather?.current?.condition?.text ?? '',
                  color: context.colors.muted,
                  fontSize: 16.font,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
