part of 'home_scaffold_key_cubit.dart';

@immutable
sealed class HomeScaffoldKeyState {
  final scaffoldKey = GlobalKey<ScaffoldState>();
}

final class HomeScaffoldKeyInitial extends HomeScaffoldKeyState {}
// final class HomeScaffoldKeyOn extends HomeScaffoldKeyState {}
// final class HomeScaffoldKeyInitial extends HomeScaffoldKeyState {}
