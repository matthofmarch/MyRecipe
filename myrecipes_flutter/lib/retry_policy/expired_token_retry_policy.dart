import 'package:auth_repository/auth_repository.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  AuthRepository _authRepository;

  ExpiredTokenRetryPolicy(this._authRepository) : super();

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      _authRepository.tryRefresh();
      return true;
    }
    return false;
  }
}