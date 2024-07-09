import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/constants/api_constants.dart';
import '../../../../core/common/provider/secure_storage_provide.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(flutterSecureStorageProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSource(this.dio, this.secureStorage);

  // Login User
  Future<Either<Failure, bool>> loginUser(
      String username, String password) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData =
            response.data as Map<String, dynamic>?;
        if (responseData != null &&
            responseData.containsKey('token') &&
            responseData.containsKey('userData')) {
          final token = responseData['token'];
          final userId = responseData['userData']['_id'];
          final usernameFromResponse = responseData['userData']['username'];

          // Store token, userId, and username in secure storage
          await secureStorage.write(key: "authToken", value: token);
          await secureStorage.write(key: "userId", value: userId);
          await secureStorage.write(
              key: "username", value: usernameFromResponse);

          return const Right(true);
        } else {
          return Left(Failure(
            error: "Missing token or user data in the response.",
            statusCode: response.statusCode.toString(),
          ));
        }
      } else {
        return Left(Failure(
          error: response.data?['message'] ?? "Unknown error",
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      return Left(Failure(error: "Network error: ${e.message}"));
    } catch (e) {
      return Left(
          Failure(error: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
