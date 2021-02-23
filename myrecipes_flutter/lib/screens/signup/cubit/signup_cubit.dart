import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupInitial());

  Future<void> load({previousEmail = ""}) async {
    emit(SignupInteraction(previousEmail));
  }

  Future<void> signup(String email, String password) async {
    emit(SignupProgress());
    try {
      await _authRepository.signup(email, password);
      emit(SignUpSuccess());
      await _authRepository.login(email, password);
    } on Exception catch (e) {
      print(e);
      emit(SignUpFailure(email));
    }
  }
}
