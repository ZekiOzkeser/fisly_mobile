/// Generic API Response wrapper for auth endpoints
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final dynamic error;

  ApiResponse({required this.success, this.data, this.message, this.error});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      error: json['error'],
    );
  }
}

class RegisterRequest {
  final String email;
  final String username;
  final String password;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'password': password,
      };
}

class RegisterResponse {
  final bool registered;
  final UserInfo user;

  RegisterResponse({required this.registered, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      registered: json['registered'] as bool,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class LoginRequest {
  final String identifier;
  final String password;

  LoginRequest({required this.identifier, required this.password});

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'password': password,
      };
}

class LoginResponse {
  final bool success;
  final String? message;
  final LoginData data;
  final dynamic error;

  LoginResponse({
    required this.success,
    this.message,
    required this.data,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'],
    );
  }
}

class LoginData {
  final String token;
  final UserInfo user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String username;
  final List<String>? roles;

  UserInfo({
    required this.id,
    required this.email,
    required this.username,
    this.roles,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      roles: json['roles'] != null
          ? (json['roles'] as List).cast<String>()
          : null,
    );
  }
}

class ResendVerificationRequest {
  final String email;

  ResendVerificationRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResendVerificationResponse {
  final bool sent;

  ResendVerificationResponse({required this.sent});

  factory ResendVerificationResponse.fromJson(Map<String, dynamic> json) {
    return ResendVerificationResponse(sent: json['sent'] as bool);
  }
}

class PasswordResetRequest {
  final String email;

  PasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class PasswordResetResponse {
  final bool sent;

  PasswordResetResponse({required this.sent});

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponse(sent: json['sent'] as bool);
  }
}

class PasswordResetConfirmRequest {
  final String token;
  final String newPassword;

  PasswordResetConfirmRequest({required this.token, required this.newPassword});

  Map<String, dynamic> toJson() => {'token': token, 'newPassword': newPassword};
}

class PasswordResetConfirmResponse {
  final bool reset;

  PasswordResetConfirmResponse({required this.reset});

  factory PasswordResetConfirmResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetConfirmResponse(reset: json['reset'] as bool);
  }
}

class AuthMeResponse {
  final String email;
  final bool isAuthenticated;
  final List<AuthClaim> claims;

  AuthMeResponse({
    required this.email,
    required this.isAuthenticated,
    required this.claims,
  });

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) {
    return AuthMeResponse(
      email: json['email'] as String,
      isAuthenticated: json['isAuthenticated'] as bool,
      claims: (json['claims'] as List)
          .map((claim) => AuthClaim.fromJson(claim as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AuthClaim {
  final String type;
  final String value;

  AuthClaim({required this.type, required this.value});

  factory AuthClaim.fromJson(Map<String, dynamic> json) {
    return AuthClaim(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }
}
