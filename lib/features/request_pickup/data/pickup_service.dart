// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../model/PickupRequest.dart';
// import '../../../config/constants/api_constants.dart';

// class PickupService {
//   Future<bool> createPickup(PickupRequest pickupRequest) async {
//     final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.createPickup;
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer your_token_here'
//       },
//       body: jsonEncode(pickupRequest.toJson()),
//     );

//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       print('Failed to create pickup request: ${response.reasonPhrase}');
//       return false;
//     }
//   }

//   Future<List<PickupRequest>> getPickupsByUserIdOrSessionId(
//       String? userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     String sessionId = prefs.getString('sessionId') ?? '';

//     final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.getAllPickups;
//     final response = await http.get(
//       Uri.parse(apiUrl).replace(queryParameters: {
//         if (userId != null) 'userId': userId,
//         'sessionId': sessionId,
//       }),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer your_token_here',
//       },
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = jsonDecode(response.body)['data'];
//       return jsonData.map((data) => PickupRequest.fromJson(data)).toList();
//     } else {
//       throw Exception(
//           'Failed to load pickups: ${response.statusCode} - ${response.reasonPhrase}');
//     }
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/PickupRequest.dart';
import '../../../config/constants/api_constants.dart';
import '../../../core/utils/helpers/user_sessions.dart';

class PickupService {
  Future<bool> createPickup(PickupRequest pickupRequest) async {
    final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.createPickup;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token_here'
      },
      body: jsonEncode(pickupRequest.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create pickup request: ${response.reasonPhrase}');
      return false;
    }
  }

  Future<List<PickupRequest>> getPickupsByUserIdOrSessionId(
      String? userId) async {
    String sessionId = await UserSession.getSessionId();

    final String apiUrl = ApiEndpoints.baseUrl + ApiEndpoints.getAllPickups;
    final response = await http.get(
      Uri.parse(apiUrl).replace(queryParameters: {
        if (userId != null) 'userId': userId,
        'sessionId': sessionId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token_here',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((data) => PickupRequest.fromJson(data)).toList();
    } else {
      throw Exception(
          'Failed to load pickups: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
