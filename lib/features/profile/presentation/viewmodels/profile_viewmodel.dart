import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../providers/providers.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetProfileUseCase _getProfileUseCase;

  @override
  ProfileState build() {
    _getProfileUseCase = ref.read(getProfileUseCaseProvider);
    return ProfileState();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final p = await _getProfileUseCase.call();
      state = state.copyWith(loading: false, profile: p);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
