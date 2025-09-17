import '../../../profile/domain/entities/profile_entity.dart';

class AuthResponseModel {
  final String authToken;
  final String refreshToken;

  AuthResponseModel({required this.authToken, required this.refreshToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      authToken: json['authToken'] ?? json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  UserEntity toEntity({String name = '', String email = ''}) {
    return UserEntity(
      authToken: authToken,
      refreshToken: refreshToken,
      name: name,
      email: email,
      clientId: '',
    );
  }
}
