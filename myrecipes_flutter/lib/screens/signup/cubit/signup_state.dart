part of 'signup_cubit.dart';

@immutable
abstract class SignupState with EquatableMixin {
  const SignupState();


  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupInteraction extends SignupState {
  final String previousEmail ;
  const SignupInteraction(this.previousEmail);

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
