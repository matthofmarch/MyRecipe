import 'package:http_interceptor/http_interceptor.dart';

class JsonContentInterceptor implements InterceptorContract {
  JsonContentInterceptor() : super();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    data.headers.addAll({"Content-Type": "application/json"});
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
