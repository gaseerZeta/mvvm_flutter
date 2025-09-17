import 'package:dio/dio.dart';

import '../../../../core/error_handling/api_expections.dart';
import '../../../../core/storage/secure_storage.dart';
import '../model/auth_response.dart';
import '../model/sign_in_model.dart';
import '../model/sign_up_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signIn(SignInRequestModel request);
  Future<AuthResponseModel> signUp(SignUpRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> signIn(SignInRequestModel request) async {
    try {
      final resp = await dio.post(
        '/api/v1/account/signin',
        data: request.toJson(),
      );

      if (resp.statusCode == 200) {
        final model = AuthResponseModel.fromJson(
          resp.data as Map<String, dynamic>,
        );
        await SecureStorage.saveTokens(model.authToken, model.refreshToken);
        return model;
      } else {
        throw ApiException(
          title: "Error",
          detail: "Unexpected error ${resp.statusCode}",
          status: resp.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final data = e.response?.data as Map;
        throw ApiException(
          title: data['title'] ?? "Request Failed",
          detail: data['detail'] ?? "Unknown error",
          status: data['status'],
        );
      }
      throw ApiException(title: "Network", detail: e.message ?? "Unknown");
    }
  }

  @override
  Future<AuthResponseModel> signUp(SignUpRequestModel request) async {
    try {
      final resp = await dio.post(
        '/api/v1/account/signup',
        data: request.toJson(),
      );
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final model = AuthResponseModel.fromJson(
          resp.data as Map<String, dynamic>,
        );
        await SecureStorage.saveTokens(model.authToken, model.refreshToken);
        return model;
      } else {
        throw ApiException(
          title: "Error",
          detail: "Unexpected error ${resp.statusCode}",
          status: resp.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final data = e.response?.data as Map;
        throw ApiException(
          title: data['title'] ?? "Request Failed",
          detail: data['detail'] ?? "Unknown error",
          status: data['status'],
        );
      }
      throw ApiException(title: "Network", detail: e.message ?? "Unknown");
    }
  }
}
