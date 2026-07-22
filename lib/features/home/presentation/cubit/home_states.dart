part of 'home_cubit.dart';

sealed class HomeStates {}

class HomeInit extends HomeStates {}

class HomeLoading extends HomeStates {}

class HomeSearching extends HomeStates {}

class HomeError extends HomeStates {
  HomeError(this.message);

  final String message;
}
