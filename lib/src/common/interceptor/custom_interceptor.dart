import 'package:dio/dio.dart';

class CustomInterCeptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Naver-Client-id'] = '7474PvfycrcJGYqPRjO0';
    options.headers['X-Naver-Client-Secret'] = 'z_k0Qypv0G';

    super.onRequest(options, handler);
  }
}
