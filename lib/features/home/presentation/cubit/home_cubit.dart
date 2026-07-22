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

  WeatherResponseModel? weather;

  String? userLocation;

  final TextEditingController searchController = TextEditingController();

  void init({String? query}) {
    unawaited(_init(query: query));
  }

  Future<void> _init({String? query}) async {
    userLocation = query ?? await LocationUtils.getCurrentCoordinates();
    if (userLocation == null) return;
    _emit(HomeLoading());
    await getCurrentWeather(query: userLocation!);
  }

  Future<void> getCurrentWeather({required String query}) async {
    final result = await _weatherRepo.getCurrentWeather(query: query);

    result.when(
      success: (weather) {
        this.weather = weather;
        _emit(HomeInit());
      },
      error: (apiError) => _emit(HomeError(apiError.getAllErrorMessages())),
    );
  }

  void clearSearch() {
    searchController.clear();
    _emit(HomeInit());
  }

  Future<void> search() async {
    _emit(HomeSearching());
    await getCurrentWeather(query: searchController.text);
  }

  bool get isLoading => state is HomeLoading;
  bool get isSearching => state is HomeSearching;

  void _emit(HomeStates state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
