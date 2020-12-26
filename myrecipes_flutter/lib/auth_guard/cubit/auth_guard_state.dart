part of 'auth_guard_cubit.dart';

abstract class AuthGuardState extends Equatable {
  const AuthGuardState();

  @override
  List<Object> get props => [];
}

class AuthGuardUnknown extends AuthGuardState {}

class AuthGuardAuthenticated extends AuthGuardState {
  final User user;

  const AuthGuardAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthGuardUnauthenticated extends AuthGuardState {}