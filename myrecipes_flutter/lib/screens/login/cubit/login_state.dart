part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable{
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final String jwt;

  LoginSuccess(this.jwt);

  @override
  // TODO: implement props
  List<Object> get props => [jwt];
}

class LoginError extends LoginState {}
