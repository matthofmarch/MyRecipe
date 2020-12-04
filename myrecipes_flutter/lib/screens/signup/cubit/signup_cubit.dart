import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupInitial());

  void signup(String email, String password) async {
    emit(SignupProgress());
    try {
      await _authRepository.signup(email, password);
      emit(SignUpSuccess());

    }catch(e){
      print(e);
      emit(SignUpFailure("Could not signup"));
    }
  }
}
