part of 'auth_guard_cubit.dart';

abstract class AuthGuardState extends Equatable {
  const AuthGuardState();
}

class AuthGuardUnknown extends AuthGuardState {
  @override
  List<Object> get props => [];
}

class AuthGuardAuthenticated extends AuthGuardState {
  final User user;

  const AuthGuardAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthGuardUnauthenticated extends AuthGuardState {
  @override
  List<Object> get props => [];
}