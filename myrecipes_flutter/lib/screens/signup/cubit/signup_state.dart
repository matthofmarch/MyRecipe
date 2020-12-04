part of 'signup_cubit.dart';

@immutable
abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];

  const SignupState();
}

class SignupInitial extends SignupState {}

class SignupProgress extends SignupState {}

class SignUpSuccess extends SignupState {}

class SignUpFailure extends SignupState {
  final String _errorMessage;

  const SignUpFailure(this._errorMessage);

  @override
  List<Object> get props => [_errorMessage];
}
