import 'package:dio/dio.dart';
import '../../../config/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user_model.dart';

class UserService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: ApiEndpoints.connectionTimeout,
    receiveTimeout: ApiEndpoints.receiveTimeout,
  ));
  final storage = FlutterSecureStorage();

  Future<User> getUserProfile() async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.get(
        'v1/user/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return User.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  Future<bool> updateUserProfile(User user) async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.put(
        'v1/user/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: user.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.get(
        'v1/user',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return (response.data['data'] as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.delete(
        'v1/user/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
