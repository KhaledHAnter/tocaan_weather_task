import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/cubits/theme/theme_cubit.dart';
import '../../../../core/helpers/app_theme.dart';
import '../../../../core/helpers/dimensions.dart';
import '../../../../core/helpers/utils.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_text_form_field.dart';
import '../../../../widgets/weather_condition_icon.dart';
import '../cubit/home_cubit.dart';

part '../widgets/actions_row.dart';
part '../widgets/data_body.dart';
part '../widgets/home_error.dart';
part '../widgets/search.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..init(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const _ActionsRow(),
                SizedBox(height: 16.height),
                const _Search(),
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      if (state is HomeError) {
                        return _HomeErrorWidget(
                          message: state.message,
                        );
                      }
                      return const _DataBody();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
