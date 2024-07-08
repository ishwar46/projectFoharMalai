import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

        if (responseData != null && responseData.containsKey('token')) {
          final token = responseData['token'];

          await secureStorage.write(key: "authToken", value: token);

          final decodedToken = JwtDecoder.decode(token);
          final tokenUsername = decodedToken['username'];

          if (username == tokenUsername) {
            await secureStorage.write(
                key: "username", value: username); // Save the username
            return const Right(true);
          } else {
            return Left(
              Failure(
                error: response.data?['message'] ?? "Invalid Username",
                statusCode: response.statusCode.toString(),
              ),
            );
          }
        } else {
          return Left(
            Failure(
              error: response.data?['message'] ?? "Unknown error",
              statusCode: response.statusCode.toString(),
            ),
          );
        }
      } else {
        return Left(
          Failure(
            error: response.data?['message'] ?? "Unknown error",
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(Failure(error: "Connection timeout. Please try again."));
      } else if (e.type == DioExceptionType.badResponse) {
        return Left(Failure(error: "Server error. Please try again later."));
      } else {
        return Left(Failure(error: "An unexpected error occurred."));
      }
    } catch (e) {
      return Left(Failure(error: "An unexpected error occurred."));
    }
  }
}
