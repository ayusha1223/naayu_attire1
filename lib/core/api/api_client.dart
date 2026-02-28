import 'package:dio/dio.dart';
import '../services/storage/token_service.dart';
import 'api_endpoints.dart';

class ApiClient {
  late final Dio dio;
  final TokenService tokenService;

  ApiClient(this.tokenService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    /// 🔥 AUTH INTERCEPTOR
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenService.getToken();

          print("TOKEN ATTACHED TO REQUEST: $token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );

    /// 🔹 Logging interceptor (keep this for viva)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}