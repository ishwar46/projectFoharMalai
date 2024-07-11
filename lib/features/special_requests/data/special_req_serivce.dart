import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/constants/api_constants.dart';
import '../../../core/common/provider/secure_storage_provide.dart';
import '../../../core/network/remote/dio_config.dart';
import '../domain/special_request.dart';

final specialRequestServiceProvider = Provider<SpecialRequestService>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.read(flutterSecureStorageProvider);
  return SpecialRequestService(dio, secureStorage);
});

class SpecialRequestService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  SpecialRequestService(this.dio, this.secureStorage);

  Future<String?> _getToken() async {
    return await secureStorage.read(key: "authToken");
  }

  Future<List<SpecialRequest>> fetchSpecialRequests() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token is not available.');

    try {
      final response = await dio.get(
        ApiEndpoints.getSpecialRequests,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data['data'];
        return jsonData.map((data) => SpecialRequest.fromJson(data)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No special requests found for the user');
      } else {
        throw Exception(
            'Failed to fetch special requests: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Network error occurred: $e');
    }
  }

  Future<bool> createSpecialRequest(SpecialRequest request) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token is not available.');

    try {
      final response = await dio.post(
        ApiEndpoints.createSpecialRequest,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to create special request: $e');
    }
  }
}
