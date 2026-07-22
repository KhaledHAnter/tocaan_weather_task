part of '../views/home_view.dart';

class _HomeErrorWidget extends StatelessWidget {
  const _HomeErrorWidget({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
