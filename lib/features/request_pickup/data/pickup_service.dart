import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/constants/api_constants.dart';
import '../../../core/network/remote/dio_error_interceptor.dart';
import '../../../core/utils/helpers/user_sessions.dart';
import '../model/PickupRequest.dart';

class PickupService {
  final Dio dio;

  PickupService()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer your_token_here',
            },
          ),
        ) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
    dio.interceptors.add(DioErrorInterceptor());
  }

  Future<bool> createPickup(PickupRequest pickupRequest) async {
    try {
      final response = await dio.post(
        ApiEndpoints.createPickup,
        data: pickupRequest.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create pickup request: ${response.statusMessage}');
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to create pickup request';
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      print(errorMessage);
      return false;
    }
  }

  Future<List<PickupRequest>> getPickupsByUserIdOrSessionId(
      String? userId) async {
    String sessionId = await UserSession.getSessionId();

    try {
      final response = await dio.get(
        ApiEndpoints.getAllPickups,
        queryParameters: {
          if (userId != null) 'userId': userId,
          if (userId == null) 'sessionId': sessionId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data['data'];
        return jsonData.map((data) => PickupRequest.fromJson(data)).toList();
      } else {
        throw Exception(
            'Failed to load pickups: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load pickups: ${e.message}');
    }
  }
}
