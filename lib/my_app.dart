import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/app_colors.dart';
import 'core/route_utils/route_utils.dart';
import 'features/home/presentation/views/home_view.dart';
import 'widgets/app_text.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Tocaan Weather',
          debugShowCheckedModeBanner: false,
          navigatorKey: RouteUtils.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: AppFontFamily.english.id,
            scaffoldBackgroundColor: AppColors.background,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          home: child,
        );
      },
      child: const HomeView(),
    );
  }
}
