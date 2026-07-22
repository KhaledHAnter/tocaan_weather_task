part of 'home_cubit.dart';

sealed class HomeStates {}

class HomeInit extends HomeStates {}

class HomeLoading extends HomeStates {}

class HomeLoaded extends HomeStates {
  HomeLoaded(this.weather);

  final WeatherResponseModel weather;
}

class HomeError extends HomeStates {
  HomeError(this.message);

  final String message;
}
