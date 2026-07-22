part of '../views/home_view.dart';

class _ActionsRow extends StatelessWidget {
  const _ActionsRow();

  @override
  Widget build(BuildContext context) {
    final cubit = ThemeCubit.of(context);
    final isAr = Utils.isAR;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(
            context,
            IconButton(
              onPressed: cubit.toggleTheme,
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_outlined,
                color: context.colors.onSurface,
              ),
            ),
          ),
          _buildActionItem(
            context,
            IconButton(
              onPressed: () {
                if (isAr) {
                  unawaited(context.setLocale(const Locale('en')));
                } else {
                  unawaited(context.setLocale(const Locale('ar')));
                }
              },
              icon: AppText(title: isAr ? 'EN' : 'ع'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border, width: 1.5),
      ),
      child: child,
    );
  }
}
