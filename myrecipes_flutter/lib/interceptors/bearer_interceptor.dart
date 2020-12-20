import 'package:auth_repository/auth_repository.dart';
import 'package:http_interceptor/http_interceptor.dart';

class BearerInterceptor implements InterceptorContract {
  AuthRepository _authRepository;
  BearerInterceptor(this._authRepository):super();

  get user async => await _authRepository.authState;

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    var accessToken = (await user).accessToken;
    if(_authRepository.tokenExpired(accessToken))
      await _authRepository.refreshAccessToken();
    accessToken = (await user).accessToken;
    data.headers.addAll({"Authorization":"Bearer ${accessToken}"});
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }

}