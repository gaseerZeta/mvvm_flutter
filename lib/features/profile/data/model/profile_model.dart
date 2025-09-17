import '../../../auth/domain/entities/user_entity.dart';

class ProfileModel {
  final String clientId;
  final String name;
  final String email;

  ProfileModel({
    required this.clientId,
    required this.name,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      clientId: json['clientId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(clientId: clientId, name: name, email: email);
  }
}
