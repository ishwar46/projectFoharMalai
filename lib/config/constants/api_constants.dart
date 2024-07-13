class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration receiveTimeout = Duration(seconds: 5);

  // For Android Emulator Device
  //static const String baseUrl = "http://10.0.2.2:5000/";

  // For IOS Emulator Device
  // static const String baseUrl = "http://localhost:5000/";

  //Base URL:

  //static const String baseUrl = "http://172.25.10.82:5500/api/";
  // static const String baseUrl = "http://192.168.10.68:5500/api/";
  static const String baseUrl = "https://foharmalaiapi-1.onrender.com/api/";

  // Auth Routes
  static const String login = "v1/auth/user/login";
  static const String register = "v1/auth/user/register";
  //PICKUP ROUTES
  static const String createPickup = "v1/pickup/create-pickup";
  static const String getAllPickups = "v1/pickup/pickups";

// Special Requests Routes
  static const String createSpecialRequest =
      "${baseUrl}v1/special-requests/create-special-req";
  static const String getSpecialRequests =
      "${baseUrl}v1/special-requests/get-special-req";

  // User Routes
  static const String userProfile = "${baseUrl}v1/user/profile";
  static const String updateUserProfile = "${baseUrl}v1/user/profile";
  static const String deleteUser = "${baseUrl}v1/user";
  static const String getAllUsers = "${baseUrl}v1/user";
}
