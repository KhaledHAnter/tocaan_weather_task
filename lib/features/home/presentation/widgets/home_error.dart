part of '../views/home_view.dart';

class _HomeErrorWidget extends StatelessWidget {
  const _HomeErrorWidget({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 48,
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.ltr,
              child: AppText(
                title: message,
                fontSize: 16.font,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
            if (cubit.userLocation != null) ...[
              const SizedBox(height: 16),
              AppButton(
                title: LocaleKeys.use_current_location.tr(context: context),
                onTap: () {
                  cubit.clearSearch();
                  unawaited(cubit.resetSearch());
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
