import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String message;
  String accessToken;
  String tokenType;
  User user;

  LoginResponseModel({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user.toJson(),
  };
}

// Model untuk User
class User {
  int id;
  String name;
  String email;
  DateTime? emailVerifiedAt;
  String role;

  // --- FIELD BARU (DITAMBAHKAN UNTUK NOTIFIKASI) ---
  String? avatarUrl;
  String? phoneNumber;
  // ------------------------------------------------

  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,

    // --- TAMBAHKAN DI CONSTRUCTOR ---
    this.avatarUrl,
    this.phoneNumber,

    // --------------------------------
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : DateTime.parse(json["email_verified_at"]),
    role: json["role"],
    avatarUrl: json["avatar_url"],
    phoneNumber: json["phone_number"],

    // ----------------------------------
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "role": role,

    // --- MAPPING FIELD BARU KE JSON ---
    "avatar_url": avatarUrl,
    "phone_number": phoneNumber,

    // ----------------------------------
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
