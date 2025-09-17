import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/data_source/profile_remote_data_source.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../viewmodels/profile_viewmodel.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);
final profileRemoteProvider = Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ProfileRemoteDataSourceImpl(dio: dio);
});

final getProfileUseCaseProvider = Provider(
  (ref) => GetProfileUseCase(ref.read(profileRemoteProvider)),
);

class ProfileState {
  final bool loading;
  final ProfileEntity? profile;
  final String? error;
  ProfileState({this.loading = false, this.profile, this.error});

  ProfileState copyWith({
    bool? loading,
    ProfileEntity? profile,
    String? error,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}
