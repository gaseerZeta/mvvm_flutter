import '../../../profile/domain/entities/profile_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(
    String name,
    String email,
    String password,
    String phone,
  );
}
