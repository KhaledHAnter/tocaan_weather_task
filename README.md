# Tocaan Weather

A Flutter weather app that looks up current conditions for a city (or the
device's current location) using [WeatherAPI](https://www.weatherapi.com/).

## Features

- Search weather by city name, or auto-detect the current location on launch
- Light/dark theme, switchable in-app and persisted across restarts
- English/Arabic localization, including full RTL support
- Offline fallback: the last successful response is cached and shown (with a
  "showing cached data" notice) if a later request fails due to no internet
- Distinct, user-facing messages for invalid city names vs. connectivity
  failures (timeout, no internet, etc.)

## Getting started

### 1. Install dependencies

```
flutter pub get
```

### 2. Run the app

```
flutter run
```

The WeatherAPI key currently lives as a hardcoded constant in
`lib/core/networking/api_constants.dart` for local development
convenience. **Before sharing this repo publicly or shipping it, rotate
that key and move it out of source control** (e.g. via `--dart-define` and
`String.fromEnvironment`, or a gitignored `.env` file) — a key committed to
git history stays retrievable even after being replaced.

### 3. Run the tests

```
flutter test
```

This runs the full unit/widget/bloc test suite. One test
(`weather_repo_impl_test.dart`) is tagged `integration` and skipped by
default because it hits the real WeatherAPI endpoint — run it explicitly
with:

```
flutter test -t integration
```

## Architecture

```
lib/
  core/                    # Cross-cutting concerns, not tied to one feature
    cubits/theme/          # App-wide theme (light/dark) state
    helpers/                 # Colors, theme extension, dimensions, shared prefs
    location_utils/          # Wraps Geolocator for current-position lookups
    networking/               # Dio setup, generic API result/error handling
    route_utils/             # Navigator key for context-free navigation
  features/home/
    data/
      models/               # Plain fromJson/toJson models mirroring the API shape
      repos/                  # WeatherRepo (interface) + WeatherRepoImpl
    presentation/
      cubit/                # HomeCubit + HomeStates — all UI state/business logic
      views/                # HomeView (screen scaffold)
      widgets/               # Screen-specific widgets, as `part of` HomeView
  widgets/                  # Reusable, feature-agnostic UI (buttons, text, etc.)
  generated/                # easy_localization's generated LocaleKeys
```

**State management:** `flutter_bloc` (Cubit). `HomeCubit` owns all
weather-fetching logic and exposes a single `HomeStates` stream
(`HomeInit` / `HomeLoading` / `HomeSearching` / `HomeError`) that
`HomeView` renders via `BlocBuilder`.

**Data flow:** `HomeView` → `HomeCubit` → `WeatherRepo` (interface) →
`WeatherRepoImpl` → `ApiService`/`Dio` → WeatherAPI. Errors are normalized
into a single `ErrorModel` by `ApiErrorHandler` regardless of whether they
came from a network failure or a well-formed API error response, so the
cubit only ever deals with one error shape.

`WeatherRepo` is injected into `HomeCubit`'s constructor (defaulting to a
real `WeatherRepoImpl`), which is what makes it possible to unit-test the
cubit's state transitions with a mocked repo instead of the network.

## Localization

Strings live in `assets/lang/{en,ar}.json` and are exposed as typed
constants via `LocaleKeys` (`lib/generated/locale_keys.g.dart`). After
adding or changing a key, regenerate it with:

```
dart run easy_localization:generate -S assets/lang -O lib/generated -o locale_keys.g.dart -f keys
```

## Known trade-offs

- No domain/use-case layer — `HomeCubit` calls `WeatherRepo` directly. For
  an app this size that extra layer would add indirection without a real
  benefit; it would be worth introducing if more features start sharing
  business logic.
- `WeatherRepoImpl` talks to a static `ApiService`/`DioFactory` with no
  injection seam, so it can't be unit-tested without hitting the network —
  that's why its test is tagged `integration` rather than mocked.
