import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:auth_repository/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_guard_state.dart';

class AuthGuardCubit extends Cubit<AuthGuardState> {
  AuthRepository _authRepository;
  AuthGuardCubit(this._authRepository) : super(AuthGuardUnknown()){
     _userSubscription = _authRepository.authStateStream.listen((u) => {
       this.emit(u == null
           ? AuthGuardUnauthenticated()
           : AuthGuardAuthenticated(u))
     });
     _authRepository.checkAuthStateAsync();
  }

  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }
}
