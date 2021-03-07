import 'package:http_interceptor/http_interceptor.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

class BearerInterceptor implements InterceptorContract {
  AuthRepository _authRepository;

  BearerInterceptor(this._authRepository) : super();

  get user async => _authRepository.authState;

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    final accessToken = (await user)?.accessToken;
    data.headers.addAll({"Authorization": "Bearer $accessToken"});
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
