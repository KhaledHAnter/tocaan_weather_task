part of '../views/home_view.dart';

class _Search extends StatelessWidget {
  const _Search();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.of(context);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppTextFormField(
            hint: LocaleKeys.search_hint.tr(context: context),
            controller: cubit.searchController,
            onFieldSubmitted: (_) => cubit.search(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppButton(
            title: LocaleKeys.search.tr(context: context),
            radius: 16,
            onTap: cubit.search,
          ),
        ),
      ],
    );
  }
}
