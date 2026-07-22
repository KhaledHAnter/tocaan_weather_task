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

  static HomeCubit of(BuildContext context) => context.watch<HomeCubit>();

  final WeatherRepo _weatherRepo;

  WeatherResponseModel? weather;

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
        // Re-using HomeInit as the "has data" state (rather than a
        // dedicated HomeLoaded) keeps HomeView's switch simple: the view
        // only needs to branch on HomeError, and renders weather/empty
        // state based on whether `weather` is null.
        _emit(HomeInit());
      },
      error: (apiError) => _emit(HomeError(apiError.getAllErrorMessages())),
    );
  }

  // Used by the error view's "use current location" action: re-runs the
  // last known-good location query without touching the search field.
  Future<void> resetSearch() async {
    if (userLocation == null) return;
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
