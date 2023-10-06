// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasir_app/app/model/user_model.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../router/app_pages.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignUpEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await _authRepository.signUp(
          shopName: event.shopName,
          name: event.name,
          email: event.email,
          password: event.password,
        );
        routerConfig.pushReplacementNamed(Routes.home);
        emit(AuthLoggedInState());
      } on FirebaseAuthException catch (e) {
        print(e.message);
        emit(AuthErrorState(e.message.toString()));
      } catch (e) {
        if (kDebugMode) {
          print('eror mboh');
          print(e);
        }
        emit(AuthErrorState(e.toString()));
      }
    });
    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await _authRepository.signIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthLoggedInState());
        routerConfig.pushReplacementNamed(Routes.home);
      } on FirebaseAuthException catch (e) {
        print(e);
        emit(AuthErrorState(e.message.toString()));
      } catch (e) {
        print('eror mboh');
        print(e);
        emit(AuthErrorState(e.toString()));
      }
    });
    on<AuthSignOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await _authRepository.logout();
        _authRepository.userModel = UserModel();
        routerConfig.pushReplacementNamed(Routes.login);
        emit(AuthLogOutState());
      } on DioException catch (e) {
        print('error dio');
        print(e.response);
        emit(AuthErrorState(e.response.toString()));
      } catch (e) {
        print('error mboh');
        print(e);
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}
