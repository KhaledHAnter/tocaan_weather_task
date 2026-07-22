import 'package:flutter_bloc/flutter_bloc.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  void setLocale(String languageCode) {
    emit(state.copyWith(languageCode: languageCode));
  }
}
