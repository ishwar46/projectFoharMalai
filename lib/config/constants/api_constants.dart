class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration receiveTimeout = Duration(seconds: 5);

  // For Android Emulator Device
  //static const String baseUrl = "http://10.0.2.2:5000/";

  // For IOS Emulator Device
  // static const String baseUrl = "http://localhost:5000/";

  //Base URL:

  // static const String baseUrl = "http://172.25.10.82:5500/api/";
  static const String baseUrl = "http://192.168.10.68:5500/api/";

  // Auth Routes
  static const String login = "v1/auth/user/login";

  static const String createPickup = "v1/pickup/create-pickup";
  static const String getAllPickups = "v1/pickup/pickups";
}
