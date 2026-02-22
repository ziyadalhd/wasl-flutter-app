import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:wasl/core/models/models.dart';

/// Centralized HTTP client for all backend REST calls.
///
/// Handles:
/// - Base URL configuration (auto-detects web vs Android emulator)
/// - JWT token injection via `Authorization` header
/// - JSON serialization / deserialization
/// - Typed error responses ([ApiException])
class ApiClient {
  /// Web (Chrome) → localhost; Android emulator → 10.0.2.2.
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  static const String _tokenKey = 'jwt_token';

  // Web-safe options for flutter_secure_storage
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    webOptions: WebOptions.defaultOptions,
  );

  // ── Token helpers ────────────────────────────────────────────────────────

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  static Future<bool> hasToken() async =>
      (await _storage.read(key: _tokenKey)) != null;

  // ── Headers ──────────────────────────────────────────────────────────────

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ── HTTP verbs ───────────────────────────────────────────────────────────

  /// Sends a **GET** request to [path] (relative to [baseUrl]).
  static Future<Map<String, dynamic>> get(
    String path, {
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.get(uri, headers: await _headers(auth: auth));
      return _handleResponse(response);
    } catch (e) {
      throw _wrapConnectionError(e);
    }
  }

  /// Sends a **POST** request with a JSON [body].
  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        uri,
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _wrapConnectionError(e);
    }
  }

  /// Sends a **PUT** request with a JSON [body].
  static Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.put(
        uri,
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _wrapConnectionError(e);
    }
  }

  /// Sends a **DELETE** request.
  static Future<Map<String, dynamic>> delete(
    String path, {
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.delete(uri, headers: await _headers(auth: auth));
      return _handleResponse(response);
    } catch (e) {
      throw _wrapConnectionError(e);
    }
  }

  // ── Response handling ────────────────────────────────────────────────────

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // 2xx — success
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return {};
      // Some endpoints return a plain String (e.g. "Mode switched to …").
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'data': decoded};
      } catch (_) {
        return {'data': response.body};
      }
    }

    // Error — try to parse ApiErrorResponse
    ApiErrorResponse? apiError;
    try {
      apiError = ApiErrorResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      // ignore parse failures
    }

    throw ApiException(
      statusCode: statusCode,
      apiError: apiError,
      rawBody: response.body,
    );
  }

  /// Wraps any network error into an [ApiException] — rethrows if already one.
  static Object _wrapConnectionError(Object error) {
    if (error is ApiException) return error;
    return ApiException(
      statusCode: 0,
      rawBody: error.toString(),
    );
  }
}

// ─── Exception ─────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final ApiErrorResponse? apiError;
  final String? rawBody;

  const ApiException({
    required this.statusCode,
    this.apiError,
    this.rawBody,
  });

  /// Returns an Arabic user-facing message based on the status code.
  String get userMessage {
    if (statusCode == 0) return 'تعذر الاتصال بالسيرفر. تأكد من تشغيل الخادم واتصالك بالإنترنت.';
    if (statusCode == 401) return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    if (statusCode == 403) return 'ليس لديك صلاحية للوصول.';
    if (statusCode == 404) return 'الحساب غير موجود.';
    if (statusCode == 409) return 'البريد الإلكتروني مسجل مسبقاً.';
    if (statusCode == 422) return 'بيانات غير صالحة. الرجاء المحاولة مرة أخرى.';
    if (statusCode >= 500) return 'خطأ في السيرفر. الرجاء المحاولة لاحقاً.';
    return apiError?.message ?? 'حدث خطأ غير متوقع. ($statusCode)';
  }

  String get message =>
      apiError?.message ?? rawBody ?? 'Unknown error ($statusCode)';

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isConflict => statusCode == 409;
  bool get isNotFound => statusCode == 404;
  bool get isConnectionError => statusCode == 0;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
