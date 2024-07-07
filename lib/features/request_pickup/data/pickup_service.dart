import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/constants/api_constants.dart';
import '../model/PickupRequest.dart';

class PickupService {
  Future<bool> createPickup(PickupRequest pickupRequest) async {
    final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.createPickup;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pickupRequest.toJson()),
    );

    if (response.statusCode == 201) {
      print('Pickup request created successfully');
      return true;
    } else {
      print('Failed to create pickup request: ${response.reasonPhrase}');
      return false;
    }
  }

  Future<List<PickupRequest>> getAllPickups() async {
    final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.getAllPickups;
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((pickup) => PickupRequest.fromJson(pickup)).toList();
    } else {
      throw Exception('Failed to load pickups');
    }
  }
}
