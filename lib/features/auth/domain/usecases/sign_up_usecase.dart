import '../../../profile/domain/entities/profile_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity> call(
    String name,
    String email,
    String password,
    String phone,
  ) {
    return repository.signUp(name, email, password, phone);
  }
}
