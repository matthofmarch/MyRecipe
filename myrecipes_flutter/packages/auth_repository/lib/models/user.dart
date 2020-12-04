import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    @required this.email,
    @required this.accessToken
  })  : assert(email != null),
        assert(accessToken != null);

  /// The current user's email address.
  final String email;
  final String accessToken;

  @override
  List<Object> get props => [email, accessToken];
}
