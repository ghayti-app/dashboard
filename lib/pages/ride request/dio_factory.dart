// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class DioFactory {
//   DioFactory._();

//   static Dio? dio;

// static Dio getDio() {
//   Dio dio = Dio();
 

//   // Add an interceptor to handle CORS preflight requests
//   dio.interceptors.add(InterceptorsWrapper(
//     onRequest: (options, handler) {
//       if (options.method == 'OPTIONS') {
//         return handler.resolve(Response(requestOptions: options, statusCode: 204));
//       }
//       return handler.next(options);
//     },
//   ));

//   return dio;
// }
//   static void addDioInterceptor() {
//     dio?.interceptors.add(
//       PrettyDioLogger(
//         requestBody: true,
//         requestHeader: true,
//         responseHeader: true,
//       ),
//     );
//   }
// }

import 'package:http/http.dart' as http;

class HttpFactory {
  static Future<http.Response> get(String url,
      {Map<String, String>? headers, required Map<String, String> queryParameters}) async {
    headers ??= {};
    headers.addAll({
      'Content-Type': 'application/json', 
      'Origin': 'https://dashboard.ghayti.app',
      'Accept': 'application/json',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age': '86400',
      // 'Access-Control-Allow-Origin': 'https://dashboard.ghayti.app',
     'Access-Control-Allow-Origin': '*',
           'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers':
      'Origin, X-Requested-With, Content-Type, Accept, Authorization',
      'Access-Control-Expose-Headers': 'Content-Length, X-Custom-Header'
    });

    return await http.get(Uri.parse(url), headers: headers);
  }
}


class CorsMiddleware extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Access-Control-Allow-Origin'] = '*';
    request.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE';
    request.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, X-Auth-Token';

    return _inner.send(request);
  }
}
