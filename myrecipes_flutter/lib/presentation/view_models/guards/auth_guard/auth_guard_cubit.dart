import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myrecipes_flutter/domain/models/auth/user.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

part 'auth_guard_state.dart';

class AuthGuardCubit extends Cubit<AuthGuardState> {
  AuthRepository _authRepository;

  AuthGuardCubit(this._authRepository) : super(AuthGuardUnknown()) {
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
