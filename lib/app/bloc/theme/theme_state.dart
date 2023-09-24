part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {
  final AppTheme appTheme;

  ThemeState({required this.appTheme});
}

final class ThemeInitial extends ThemeState {
  ThemeInitial({required super.appTheme});
}

final class ThemeDarkState extends ThemeState {
  ThemeDarkState({required super.appTheme});
}

final class ThemeLightState extends ThemeState {
  ThemeLightState({required super.appTheme});
}
