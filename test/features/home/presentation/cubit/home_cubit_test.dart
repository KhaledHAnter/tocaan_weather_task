import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tocaan_weather_task/core/networking/api_result.dart';
import 'package:tocaan_weather_task/core/networking/error_model.dart';
import 'package:tocaan_weather_task/features/home/data/models/condition_model.dart';
import 'package:tocaan_weather_task/features/home/data/models/current_weather_model.dart';
import 'package:tocaan_weather_task/features/home/data/models/location_model.dart';
import 'package:tocaan_weather_task/features/home/data/models/weather_response_model.dart';
import 'package:tocaan_weather_task/features/home/data/repos/weather_repo.dart';
import 'package:tocaan_weather_task/features/home/presentation/cubit/home_cubit.dart';

class _MockWeatherRepo extends Mock implements WeatherRepo {}

WeatherResponseModel _weatherFor(String city) => WeatherResponseModel(
  location: LocationModel(name: city, country: city),
  current: CurrentWeatherModel(
    tempC: 25,
    condition: ConditionModel(text: 'Sunny', code: 1000),
  ),
);

void main() {
  late _MockWeatherRepo repo;

  setUp(() {
    repo = _MockWeatherRepo();
    // HomeCubit persists successful responses via SharedPrefHelper; give it
    // a real (mocked-platform-channel) prefs instance so those calls don't
    // throw MissingPluginException in a pure Dart test environment.
    SharedPreferences.setMockInitialValues({});
  });

  group('search', () {
    blocTest<HomeCubit, HomeStates>(
      'does nothing when the search field is empty',
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) => cubit.search(),
      expect: () => <HomeStates>[],
      verify: (_) => verifyNever(
        () => repo.getCurrentWeather(query: any(named: 'query')),
      ),
    );

    blocTest<HomeCubit, HomeStates>(
      'emits [HomeSearching, HomeInit] and stores the weather on success',
      setUp: () {
        when(
          () => repo.getCurrentWeather(query: 'cairo'),
        ).thenAnswer((_) async => ApiResult.success(_weatherFor('Cairo')));
      },
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) {
        cubit.searchController.text = 'cairo';
        return cubit.search();
      },
      expect: () => [isA<HomeSearching>(), isA<HomeInit>()],
      verify: (cubit) {
        expect(cubit.weather?.location?.name, 'Cairo');
        expect(cubit.isShowingCachedData, isFalse);
      },
    );

    blocTest<HomeCubit, HomeStates>(
      'emits [HomeSearching, HomeError] for an invalid city, without '
      'falling back to any cache',
      setUp: () {
        when(() => repo.getCurrentWeather(query: 'notacity')).thenAnswer(
          (_) async => ApiResult.error(
            ErrorModel(message: 'No matching location found.'),
          ),
        );
      },
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) {
        cubit.searchController.text = 'notacity';
        return cubit.search();
      },
      expect: () => [
        isA<HomeSearching>(),
        isA<HomeError>().having(
          (s) => s.message,
          'message',
          'No matching location found.',
        ),
      ],
    );
  });

  group('getCurrentWeather - offline caching', () {
    blocTest<HomeCubit, HomeStates>(
      'falls back to the cached weather on a connection error, and marks '
      'it as cached data instead of emitting HomeError',
      setUp: () {
        SharedPreferences.setMockInitialValues({
          'cached_weather': '''
          {"location": {"name": "Giza"}, "current": {"temp_c": 30}}
          ''',
        });
        when(
          () => repo.getCurrentWeather(query: any(named: 'query')),
        ).thenAnswer(
          (_) async => ApiResult.error(
            ErrorModel(message: 'No internet', isConnectionError: true),
          ),
        );
      },
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) => cubit.getCurrentWeather(query: 'giza'),
      expect: () => [isA<HomeInit>()],
      verify: (cubit) {
        expect(cubit.weather?.location?.name, 'Giza');
        expect(cubit.isShowingCachedData, isTrue);
      },
    );

    blocTest<HomeCubit, HomeStates>(
      'emits HomeError on a connection error when no cache exists',
      setUp: () {
        when(
          () => repo.getCurrentWeather(query: any(named: 'query')),
        ).thenAnswer(
          (_) async => ApiResult.error(
            ErrorModel(message: 'No internet', isConnectionError: true),
          ),
        );
      },
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) => cubit.getCurrentWeather(query: 'giza'),
      expect: () => [isA<HomeError>()],
      verify: (cubit) => expect(cubit.isShowingCachedData, isFalse),
    );
  });

  group('resetSearch', () {
    blocTest<HomeCubit, HomeStates>(
      'does nothing when there is no known user location',
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) => cubit.resetSearch(),
      expect: () => <HomeStates>[],
    );

    blocTest<HomeCubit, HomeStates>(
      're-queries the last known location',
      setUp: () {
        when(
          () => repo.getCurrentWeather(query: '30.0,31.0'),
        ).thenAnswer((_) async => ApiResult.success(_weatherFor('Cairo')));
      },
      build: () => HomeCubit(weatherRepo: repo),
      act: (cubit) async {
        // Passing an explicit query short-circuits the `??`, so init()
        // sets `userLocation` without awaiting LocationUtils/Geolocator —
        // giving resetSearch a known location to replay. init() itself is
        // fire-and-forget, so pump a microtask before continuing.
        cubit.init(query: '30.0,31.0');
        await Future<void>.delayed(Duration.zero);
        await cubit.resetSearch();
      },
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeInit>(),
        isA<HomeLoading>(),
        isA<HomeInit>(),
      ],
      verify: (cubit) => expect(cubit.userLocation, '30.0,31.0'),
    );
  });

  group('clearSearch', () {
    blocTest<HomeCubit, HomeStates>(
      'clears the search field and returns to HomeInit',
      build: () => HomeCubit(weatherRepo: repo),
      seed: () => HomeError('some error'),
      act: (cubit) {
        cubit.searchController.text = 'cairo';
        cubit.clearSearch();
      },
      expect: () => [isA<HomeInit>()],
      verify: (cubit) => expect(cubit.searchController.text, isEmpty),
    );
  });
}
