import 'package:dio/dio.dart';

import '../model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final resp = await dio.get('/api/v1/account/profile');
      return ProfileModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    }
  }
}
