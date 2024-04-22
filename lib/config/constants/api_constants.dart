class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration receiveTimeout = Duration(seconds: 5);

  // For Android Emulator Device
  //static const String baseUrl = "http://10.0.2.2:5000/";

  // For IOS Emulator Device
  // static const String baseUrl = "http://localhost:5000/";

  //Base URL:

  static const String baseUrl = "http://172.25.1.242:6011/api/";

  // Auth Routes
  static const String login = "AuthAPI/Auth/GetToken";

  //DropDown
  static const String getDropDownList = "AuthAPI/Utility/GetDropDownList";

  //Staff Info
  static const String staffInfo = "CareMgmt/StaffInfo/GetStaffById";
}
