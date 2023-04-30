import 'package:dio/dio.dart';

class ApiClient {
  static Dio dio() {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://dummyjson.com/",
    );

    var _dio = Dio(options);
    _dio.options.extra['withCredentials'] = true;
    return _dio;
  }

  Future<Response> fetch(String endpoint,
      {Map<String, dynamic>? headers, CancelToken? cancelToken}) async {
    try {
      final response = await dio().get(
        Uri.encodeFull(endpoint),
        queryParameters: headers,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      final response = await dio().post(
        Uri.encodeFull(endpoint),
        data: data,
        queryParameters: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      final response = await dio().put(
        Uri.encodeFull(endpoint),
        data: data,
        queryParameters: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
