part of 'general_cubit.dart';

class GeneralState {
  const GeneralState({this.languageCode = 'en'});

  final String languageCode;

  GeneralState copyWith({String? languageCode}) {
    return GeneralState(languageCode: languageCode ?? this.languageCode);
  }
}
