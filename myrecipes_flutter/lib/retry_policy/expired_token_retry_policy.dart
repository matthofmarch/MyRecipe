import 'package:http_interceptor/http_interceptor.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  AuthRepository _authRepository;

  ExpiredTokenRetryPolicy(this._authRepository) : super();

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      _authRepository.refreshAsync();
      return true;
    }
    return false;
  }
}
