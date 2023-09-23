import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_scaffold_key_state.dart';

class HomeScaffoldKeyCubit extends Cubit<HomeScaffoldKeyState> {
  HomeScaffoldKeyCubit() : super(HomeScaffoldKeyInitial());

  void drawerOn() {
    state.scaffoldKey.currentState?.openDrawer();
  }

  void drawerOff() {
    state.scaffoldKey.currentState?.closeDrawer();
  }
}
