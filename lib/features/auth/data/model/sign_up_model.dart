class SignUpRequestModel {
  final String name;
  final String emailAddress;
  final String password;
  final String phoneNumber;

  SignUpRequestModel({
    required this.name,
    required this.emailAddress,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "emailAddress": emailAddress,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }
}
