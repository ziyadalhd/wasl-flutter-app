// Dart data models mirroring all Spring Boot DTOs.
// JSON keys match Java field names exactly (camelCase via Jackson).

// ─── Auth ────────────────────────────────────────────────────────────────────

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String email;
  final String? phone;
  final String password;
  final String fullName;
  final String mode; // "STUDENT" | "PROVIDER"
  final List<String> rolesWanted;

  const RegisterRequest({
    required this.email,
    this.phone,
    required this.password,
    required this.fullName,
    required this.mode,
    required this.rolesWanted,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'fullName': fullName,
        'mode': mode,
        'rolesWanted': rolesWanted,
      };
}

class AuthResponse {
  final String token;

  const AuthResponse({required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      AuthResponse(token: json['token'] as String);
}

// ─── Me / Profile ────────────────────────────────────────────────────────────

class UserDTO {
  final String id;
  final String email;
  final String? phone;
  final String fullName;
  final String selectedMode;
  final String status;
  final List<String> roles;

  const UserDTO({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    required this.selectedMode,
    required this.status,
    required this.roles,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        id: json['id'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        fullName: json['fullName'] as String,
        selectedMode: json['selectedMode'] as String,
        status: json['status'] as String,
        roles: (json['roles'] as List<dynamic>).cast<String>(),
      );
}

class StudentProfileDTO {
  final String? universityId;
  final String? collegeName;

  const StudentProfileDTO({this.universityId, this.collegeName});

  factory StudentProfileDTO.fromJson(Map<String, dynamic> json) =>
      StudentProfileDTO(
        universityId: json['universityId'] as String?,
        collegeName: json['collegeName'] as String?,
      );
}

class ProviderDocumentDTO {
  final String id;
  final String url;

  const ProviderDocumentDTO({required this.id, required this.url});

  factory ProviderDocumentDTO.fromJson(Map<String, dynamic> json) =>
      ProviderDocumentDTO(
        id: json['id'] as String,
        url: json['url'] as String,
      );
}

class ProviderProfileDTO {
  final String? bio;
  final String? verificationStatus;
  final String? providerType;
  final List<ProviderDocumentDTO>? documents;

  const ProviderProfileDTO({
    this.bio,
    this.verificationStatus,
    this.providerType,
    this.documents,
  });

  factory ProviderProfileDTO.fromJson(Map<String, dynamic> json) =>
      ProviderProfileDTO(
        bio: json['bio'] as String?,
        verificationStatus: json['verificationStatus'] as String?,
        providerType: json['providerType'] as String?,
        documents: json['documents'] != null
            ? (json['documents'] as List<dynamic>)
                .map((d) =>
                    ProviderDocumentDTO.fromJson(d as Map<String, dynamic>))
                .toList()
            : null,
      );
}

class MeResponse {
  final UserDTO user;
  final String mode;

  /// Either [StudentProfileDTO] or [ProviderProfileDTO] depending on [mode].
  final dynamic profile;

  const MeResponse({
    required this.user,
    required this.mode,
    this.profile,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    final mode = json['mode'] as String;
    final profileJson = json['profile'] as Map<String, dynamic>?;
    dynamic profile;
    if (profileJson != null) {
      if (mode == 'STUDENT') {
        profile = StudentProfileDTO.fromJson(profileJson);
      } else {
        profile = ProviderProfileDTO.fromJson(profileJson);
      }
    }
    return MeResponse(
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      mode: mode,
      profile: profile,
    );
  }
}

class SwitchModeRequest {
  final String mode;

  const SwitchModeRequest({required this.mode});

  Map<String, dynamic> toJson() => {'mode': mode};
}

// ─── Home Feed ───────────────────────────────────────────────────────────────

class ProfileCompletionDTO {
  final int percentage;
  final List<String> missingFields;

  const ProfileCompletionDTO({
    required this.percentage,
    required this.missingFields,
  });

  factory ProfileCompletionDTO.fromJson(Map<String, dynamic> json) =>
      ProfileCompletionDTO(
        percentage: json['percentage'] as int,
        missingFields:
            (json['missingFields'] as List<dynamic>).cast<String>(),
      );
}

class ApartmentListingDTO {
  final String id;
  final String title;
  final String city;
  final double price;
  final String? createdAt;

  const ApartmentListingDTO({
    required this.id,
    required this.title,
    required this.city,
    required this.price,
    this.createdAt,
  });

  factory ApartmentListingDTO.fromJson(Map<String, dynamic> json) =>
      ApartmentListingDTO(
        id: json['id'] as String,
        title: json['title'] as String,
        city: json['city'] as String,
        price: (json['price'] as num).toDouble(),
        createdAt: json['createdAt'] as String?,
      );
}

class TransportSubscriptionDTO {
  final String id;
  final String name;
  final double price;
  final String? createdAt;

  const TransportSubscriptionDTO({
    required this.id,
    required this.name,
    required this.price,
    this.createdAt,
  });

  factory TransportSubscriptionDTO.fromJson(Map<String, dynamic> json) =>
      TransportSubscriptionDTO(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        createdAt: json['createdAt'] as String?,
      );
}

class StudentHomeResponseDTO {
  final List<ApartmentListingDTO> listings;
  final List<TransportSubscriptionDTO> subscriptions;
  final ProfileCompletionDTO profileCompletion;

  const StudentHomeResponseDTO({
    required this.listings,
    required this.subscriptions,
    required this.profileCompletion,
  });

  factory StudentHomeResponseDTO.fromJson(Map<String, dynamic> json) =>
      StudentHomeResponseDTO(
        listings: (json['listings'] as List<dynamic>)
            .map((e) =>
                ApartmentListingDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
        subscriptions: (json['subscriptions'] as List<dynamic>)
            .map((e) => TransportSubscriptionDTO.fromJson(
                e as Map<String, dynamic>))
            .toList(),
        profileCompletion: ProfileCompletionDTO.fromJson(
            json['profileCompletion'] as Map<String, dynamic>),
      );
}

// ─── Error ───────────────────────────────────────────────────────────────────

class ApiErrorResponse {
  final String? timestamp;
  final int status;
  final String? error;
  final String? message;
  final String? path;
  final Map<String, String>? validationErrors;

  const ApiErrorResponse({
    this.timestamp,
    required this.status,
    this.error,
    this.message,
    this.path,
    this.validationErrors,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      ApiErrorResponse(
        timestamp: json['timestamp'] as String?,
        status: json['status'] as int,
        error: json['error'] as String?,
        message: json['message'] as String?,
        path: json['path'] as String?,
        validationErrors: json['validationErrors'] != null
            ? (json['validationErrors'] as Map<String, dynamic>)
                .map((k, v) => MapEntry(k, v as String))
            : null,
      );
}
