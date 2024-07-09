import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/constants/api_constants.dart';
import '../domain/special_request.dart';

final specialRequestServiceProvider =
    Provider((ref) => SpecialRequestService());

class SpecialRequestService {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await secureStorage.read(key: "authToken");
  }

  Future<List<SpecialRequest>> fetchSpecialRequests() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('You are not authorized to view this.');
    }

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getSpecialRequests),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body)['data'];
        return body
            .map((dynamic item) => SpecialRequest.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load special requests: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to load special requests: $error');
    }
  }

  Future<SpecialRequest> createSpecialRequest(
      SpecialRequest request, String token) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('You are not authorized to view this.');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.createSpecialRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return SpecialRequest.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to create special request: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to create special request: $error');
    }
  }
}
