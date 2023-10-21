import 'package:bloc/bloc.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeLightState(appTheme: AppTheme.light()));

  void themeDark() {
    emit(ThemeDarkState(appTheme: AppTheme.dark()));
  }

  void themeLight() {
    emit(ThemeLightState(appTheme: AppTheme.light()));
  }
}
