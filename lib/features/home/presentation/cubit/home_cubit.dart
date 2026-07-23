import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/shared_pref_helper.dart';
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

  static HomeCubit of(BuildContext context) => context.watch<HomeCubit>();

  final WeatherRepo _weatherRepo;

  WeatherResponseModel? weather;

  // True when `weather` is the last cached response rather than a fresh
  // fetch (the last request failed due to connectivity and a cache existed
  // to fall back on). Cleared as soon as a fresh fetch succeeds.
  bool isShowingCachedData = false;

  String? userLocation;

  final TextEditingController searchController = TextEditingController();

  // Fire-and-forget entry point: the constructor calls `init()` before the
  // widget tree can await it, so the async work is split into `_init` and
  // dispatched without blocking cubit creation.
  void init({String? query}) {
    unawaited(_init(query: query));
  }

  Future<void> _init({String? query}) async {
    // Explicit query wins (e.g. a saved/deep-linked city); otherwise fall
    // back to the device's current coordinates. If neither is available
    // (permission denied, GPS off) we deliberately leave the UI in its
    // initial state rather than emitting an error the user can't act on.
    _emit(HomeLoading());
    userLocation = query ?? await LocationUtils.getCurrentCoordinates();
    if (userLocation == null) {
      _emit(HomeInit());
      return;
    }
    await getCurrentWeather(query: userLocation!);
  }

  Future<void> getCurrentWeather({required String query}) async {
    final result = await _weatherRepo.getCurrentWeather(query: query);

    await result.when(
      success: (weather) async {
        this.weather = weather;
        isShowingCachedData = false;
        // Re-using HomeInit as the "has data" state (rather than a
        // dedicated HomeLoaded) keeps HomeView's switch simple: the view
        // only needs to branch on HomeError, and renders weather/empty
        // state based on whether `weather` is null.
        _emit(HomeInit());
        unawaited(
          SharedPrefHelper.setString(
            SharedPrefHelper.cachedWeatherKey,
            jsonEncode(weather.toJson()),
          ),
        );
      },
      error: (apiError) async {
        // Only fall back to a stale cache for connectivity failures (no
        // internet, timeout) — an invalid city name is a real answer from
        // the API and showing old data for it would be misleading.
        if (apiError.isConnectionError) {
          final cached = await _loadCachedWeather();
          if (cached != null) {
            weather = cached;
            isShowingCachedData = true;
            _emit(HomeInit());
            return;
          }
        }
        _emit(HomeError(apiError.getAllErrorMessages()));
      },
    );
  }

  Future<WeatherResponseModel?> _loadCachedWeather() async {
    final raw = await SharedPrefHelper.getString(
      SharedPrefHelper.cachedWeatherKey,
    );
    if (raw == null) return null;
    return WeatherResponseModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  // Used by the error view's "use current location" action: re-runs the
  // last known-good location query without touching the search field.
  Future<void> resetSearch() async {
    if (userLocation == null && weather != null) return;
    _emit(HomeLoading());
    await getCurrentWeather(query: userLocation!);
  }

  void clearSearch() {
    searchController.clear();
    _emit(HomeInit());
  }

  Future<void> search() async {
    if (searchController.text.trim().isEmpty) return;
    // Distinct from HomeLoading so the UI can tell "searching by city name"
    // apart from "resolving the device's location" if it ever needs to.
    _emit(HomeSearching());
    await getCurrentWeather(query: searchController.text);
  }

  bool get isLoading => state is HomeLoading;
  bool get isSearching => state is HomeSearching;

  // Guards every emit against the cubit being closed mid-flight (e.g. the
  // widget was disposed while an await above was still pending), which
  // would otherwise throw a StateError from bloc.
  void _emit(HomeStates state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
