import '../../../profile/domain/entities/profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
import '../model/sign_in_model.dart';
import '../model/sign_up_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final request = SignInRequestModel(emailAddress: email, password: password);

    final res = await remoteDataSource.signIn(request);

    return UserEntity(
      authToken: res.authToken,
      refreshToken: res.refreshToken,
      name: '',
      email: email,
      clientId: '',
    );
  }

  @override
  Future<UserEntity> signUp(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final request = SignUpRequestModel(
      name: name,
      emailAddress: email,
      password: password,
      phoneNumber: phone,
    );

    final res = await remoteDataSource.signUp(request);

    return UserEntity(
      authToken: res.authToken,
      refreshToken: res.refreshToken,
      name: name,
      email: email,
      clientId: '',
    );
  }
}
