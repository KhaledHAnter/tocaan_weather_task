part of '../views/home_view.dart';

class _Search extends StatelessWidget {
  const _Search();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.of(context);
    return Row(
      children: [
        const Expanded(
          child: AppTextFormField(
            hint: 'Search',
          ),
        ),
        Expanded(
          child: AppButton(
            title: 'Search',
            onTap: () => cubit.getCurrentWeather(query: 'egypt'),
          ),
        ),
      ],
    );
  }
}
