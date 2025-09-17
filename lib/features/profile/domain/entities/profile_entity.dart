class UserEntity {
  final String authToken;
  final String refreshToken;
  final String name;
  final String email;
  final String clientId;

  UserEntity({
    required this.authToken,
    required this.refreshToken,
    required this.name,
    required this.email,
    required this.clientId,
  });
}
