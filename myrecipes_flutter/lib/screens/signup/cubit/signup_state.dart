part of 'signup_cubit.dart';

@immutable
abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];

  const SignupState();
}
class SignupInitial extends SignupState {}

class SignupInteraction extends SignupState {
  String previousEmail ;
  SignupInteraction(this.previousEmail);

  @override
  List<Object> get props =>[previousEmail];
}

class SignupProgress extends SignupState {}

class SignUpSuccess extends SignupState {}

class SignUpFailure extends SignupState {
  final String previousEmail;

  const SignUpFailure(this.previousEmail);

  @override
  List<Object> get props => [previousEmail];
}
