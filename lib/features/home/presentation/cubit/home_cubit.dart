import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location_utils/location_utils.dart';
import '../../../../core/networking/api_result.dart';
import '../../data/models/weather_response_model.dart';
import '../../data/repos/weather_repo.dart';
import '../../data/repos/weather_repo_impl.dart';

part 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit({WeatherRepo? weatherRepo})
    : _weatherRepo = weatherRepo ?? WeatherRepoImpl(),
      super(HomeInit());

  static HomeCubit of(BuildContext context) => BlocProvider.of(context);

  final WeatherRepo _weatherRepo;

  static const String _fallbackQuery = 'egypt';

  void init({String? query}) {
    unawaited(_init(query: query));
  }

  Future<void> _init({String? query}) async {
    final resolvedQuery = query ?? await LocationUtils.getCurrentCoordinates();
    await getCurrentWeather(query: resolvedQuery ?? _fallbackQuery);
  }

  Future<void> getCurrentWeather({required String query}) async {
    emit(HomeLoading());

    final result = await _weatherRepo.getCurrentWeather(query: query);

    result.when(
      success: (weather) => emit(HomeLoaded(weather)),
      error: (apiError) => emit(HomeError(apiError.getAllErrorMessages())),
    );
  }
}
