import 'package:wasl/core/models/models.dart';
import 'package:wasl/core/services/api_client.dart';

/// High‑level service that wraps every auth & profile REST endpoint.
///
/// All methods throw [ApiException] on HTTP errors or [SocketException] on
/// network issues — callers are responsible for catching and presenting
/// user‑facing messages.
class AuthService {
  const AuthService._();

  // ── Auth ─────────────────────────────────────────────────────────────────

  /// `POST /api/auth/login` → stores JWT → returns [AuthResponse].
  static Future<AuthResponse> login(String email, String password) async {
    final body = LoginRequest(email: email, password: password).toJson();
    final json = await ApiClient.post('/api/auth/login', body: body, auth: false);
    final authResponse = AuthResponse.fromJson(json);
    await ApiClient.saveToken(authResponse.token);
    return authResponse;
  }

  /// `POST /api/auth/register` → stores JWT → returns [AuthResponse].
  static Future<AuthResponse> register({
    required String email,
    String? phone,
    required String password,
    required String fullName,
    required String mode,
    required List<String> rolesWanted,
  }) async {
    final body = RegisterRequest(
      email: email,
      phone: phone,
      password: password,
      fullName: fullName,
      mode: mode,
      rolesWanted: rolesWanted,
    ).toJson();
    final json =
        await ApiClient.post('/api/auth/register', body: body, auth: false);
    final authResponse = AuthResponse.fromJson(json);
    await ApiClient.saveToken(authResponse.token);
    return authResponse;
  }

  // ── Profile ──────────────────────────────────────────────────────────────

  /// `GET /api/me` → returns [MeResponse] (user + mode + profile).
  static Future<MeResponse> getMe() async {
    final json = await ApiClient.get('/api/me');
    return MeResponse.fromJson(json);
  }

  /// `PUT /api/me/profile` → updates profile → returns updated [MeResponse].
  static Future<MeResponse> updateProfile(Map<String, dynamic> data) async {
    final json = await ApiClient.put('/api/me/profile', body: data);
    return MeResponse.fromJson(json);
  }

  /// `DELETE /api/me` → soft-deletes account.
  static Future<void> deleteAccount() async {
    await ApiClient.delete('/api/me');
  }

  /// `PUT /api/me/mode` → switches active mode.
  static Future<void> switchMode(String mode) async {
    final body = SwitchModeRequest(mode: mode).toJson();
    await ApiClient.put('/api/me/mode', body: body);
  }

  /// `GET /api/colleges` → returns list of college maps.
  static Future<List<Map<String, dynamic>>> getColleges() async {
    final json = await ApiClient.get('/api/colleges', auth: false);
    final list = json['data'] as List<dynamic>;
    return list
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  // ── Home Feed ────────────────────────────────────────────────────────────

  /// `GET /api/home/student` → returns [StudentHomeResponseDTO].
  static Future<StudentHomeResponseDTO> getStudentHome() async {
    final json = await ApiClient.get('/api/home/student');
    return StudentHomeResponseDTO.fromJson(json);
  }

  // ── Session ──────────────────────────────────────────────────────────────

  /// Whether a JWT token is stored locally.
  static Future<bool> isLoggedIn() => ApiClient.hasToken();

  /// Clears the stored token (local logout).
  static Future<void> logout() => ApiClient.deleteToken();
}
