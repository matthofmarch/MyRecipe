import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:auth_repository/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_guard_state.dart';

class AuthGuardCubit extends Cubit<AuthGuardState> {
  AuthRepository _authRepository;
  AuthGuardCubit(this._authRepository) : super(AuthGuardUnknown()){
     _authRepository.tryOpenSession();
     _userSubscription = _authRepository.userStream.listen((u) => {
       this.emit(u == null
           ? AuthGuardUnauthenticated()
           : AuthGuardAuthenticated(u))
     });
  }

  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }


}
