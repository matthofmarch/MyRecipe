import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User with EquatableMixin {
  /// {@macro user}
  const User({@required this.email, @required this.accessToken, this.isAdmin})
      : assert(email != null),
        assert(accessToken != null),
        assert(isAdmin != null);

  /// The current user's email address.
  final String email;
  final String accessToken;
  final bool isAdmin;

  @override
  List<Object> get props => [email, accessToken, isAdmin];
}
