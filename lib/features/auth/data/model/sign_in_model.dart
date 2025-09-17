class SignInRequestModel {
  final String emailAddress;
  final String password;

  SignInRequestModel({required this.emailAddress, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": emailAddress, "password": password};
  }
}
