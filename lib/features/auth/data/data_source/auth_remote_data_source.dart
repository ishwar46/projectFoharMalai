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

  //Login Staff
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
        final responseData = response.data;
        if (responseData.containsKey('data') &&
            responseData['data'] != null &&
            responseData['data'].containsKey('jwtToken') &&
            responseData.containsKey('succeeded') &&
            responseData['succeeded'] == true) {
          final token = responseData['data']['jwtToken'];
          final username = responseData['data']['userName'];
          // Save JWT Token
          await secureStorage.write(key: "authToken", value: token);
          // Save Username
          await secureStorage.write(key: "username", value: username);
          // Check if login succeeded and token is not empty
          if (token.isNotEmpty) {
            return const Right(true);
          } else {
            return Left(Failure(error: "Login failed. Please try again."));
          }
        } else if (responseData.containsKey('messages')) {
          // Failed login attempt due to incorrect credentials
          final errorMessage = responseData['messages'];
          return Left(Failure(error: errorMessage));
        } else {
          return Left(Failure(error: "Invalid response data."));
        }
      } else {
        return Left(Failure(
          error: response.data?['message'] ?? "Unknown error",
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(Failure(error: "Connection timeout. Please Try again."));
      } else if (e.type == DioExceptionType.badResponse) {
        return Left(Failure(error: "Bad server response. Please Try again."));
      } else {
        return Left(Failure(error: "An Unexpected error occurred"));
      }
    } catch (e) {
      return Left(Failure(error: "Unexpected Error: $e"));
    }
  }
}
