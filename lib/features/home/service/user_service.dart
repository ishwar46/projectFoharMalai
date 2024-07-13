import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/constants/api_constants.dart';
import '../../payment/model/transaction_model.dart';
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
    } catch (e, stackTrace) {
      print('Failed to load user profile: $e');
      print(stackTrace);
      throw Exception('Failed to load user profile');
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
    } catch (e, stackTrace) {
      print('Failed to update user profile: $e');
      print(stackTrace);
      throw Exception('Failed to update user profile');
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
    } catch (e, stackTrace) {
      print('Failed to load users: $e');
      print(stackTrace);
      throw Exception('Failed to load users');
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
    } catch (e, stackTrace) {
      print('Failed to delete user: $e');
      print(stackTrace);
      throw Exception('Failed to delete user');
    }
  }

  Future<bool> makePayment(
      int amount, String receiverPhoneNumber, String purpose) async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}v1/payments/deduct-balance',
        data: jsonEncode({
          'amount': amount,
          'receiverPhoneNumber': receiverPhoneNumber,
          'purpose': purpose,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        return true;
      } else {
        print('Payment failed: ${response.data['message']}');
        return false;
      }
    } catch (e, stackTrace) {
      print('Failed to make payment: $e');
      print(stackTrace);
      throw Exception('Failed to make payment');
    }
  }

  Future<List<Transaction>> getUserTransactions() async {
    try {
      final token = await storage.read(key: 'authToken');
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}v1/payments/transaction-logs',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e, stackTrace) {
      print('Failed to load transactions: $e');
      print(stackTrace);
      throw Exception('Failed to load transactions');
    }
  }
}
