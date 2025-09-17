import '../../../auth/domain/entities/user_entity.dart';
import '../../data/data_source/profile_remote_data_source.dart';

class GetProfileUseCase {
  final ProfileRemoteDataSource remote;

  GetProfileUseCase(this.remote);

  Future<ProfileEntity> call() async {
    final model = await remote.getProfile();
    return model.toEntity();
  }
}
