import '../../features/auth/presentation/view/login_page.dart';
import '../../features/auth/presentation/view/register_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/prelogin/presentation/view/pre_login_view.dart';
import '../../features/request_pickup/presentation/request_pickup_page.dart';
import '../../features/special_requests/presentation/view/special_requests_view.dart';
import '../../features/splash_screen/splash_screen_view.dart';
import '../../features/what_we_buy/view/what_we_buy_page.dart';

class MyRoutes {
  MyRoutes._();

  static const String splashRoute = '/splash';
  static String homeRoute = "/home";
  static String loginRoute = "/loginpage";
  static String signupRoute = "/registerpage";
  static String whatWeBuyRoute = "/whatwebuyRoute";
  static String onBoardingRoute = "/onboardingpage";
  static String staffDetailsRoute = "/staffdetails";
  static String preloginRoute = "/preloginpage";
  static String settingsRoute = "/settings";
  static String viewbookedappointment = "/viewbookedappointment";
  static String userProfileRoute = "/userprofile";
  static String viewNotificationRoute = "/viewNotificationRoute";
  static String sendOTPRoute = "/sendOTPRoute";
  static String verifyOTPRoute = "/verifyOTPRoute";
  static String homePageRoute = "/homePageRoute";
  static String qrCodeRoute = "/qrCodeRoute";
  static String paymentRoute = "/paymentRoute";
  static String clientRoute = "/clientRoute";
  static String notesRoute = "/notesRoute";
  static String dashboardRoute = "/dashboardRoute";
  static String specialRequestsRoute = "/specialRequestsRoute";
  static String exampleRoute = '/exampleRoute';
  static String shiftClockInOutRoute = '/shiftClockInOutRoute';
  static String shiftDetailsMainRoute = '/shiftDetailsMainRoute';
  static String mapSampleRoute = '/MapSample';
  static String taskViewRoute = '/tasksViewRoute';
  static String staffDetailsFormRoute = '/staffDetailsFormRoute';

  static getApplicationRoute() {
    return {
      // // homeRoute: (context) => HomePage(),
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => RegisterView(),
      whatWeBuyRoute: (context) => WhatWeBuyPage(),
      splashRoute: (context) => SplashScreen(),
      // onBoardingRoute: (context) => OnBoardingScreen(),
      // // staffDetailsRoute: (context) => AddStaffView(),
      preloginRoute: (context) => const PreLoginPage(),
      // // viewbookedappointment: (context) => ViewBookedAppointments(),
      // // settingsRoute: (context) => SettingsView(),
      // userProfileRoute: (context) => StaffProfile(),
      // // viewNotificationRoute: (context) => NotificationView(),
      // // sendOTPRoute: (context) => SendOTPView(),
      // // verifyOTPRoute: (context) => VerifyOTPPage(),
      homePageRoute: (context) => HomePageNew(),
      // // qrCodeRoute: (context) => QRCodeView(),
      // // paymentRoute: (context) => Payment(),
      // // clientRoute: (context) => StaffViewNew(),
      // taskViewRoute: (context) => TasksView(),
      // dashboardRoute: (context) => DashboardView(),
      // //userInformationRoute: (context) => UserInformationView(),
      specialRequestsRoute: (context) => SpecialRequestsPage(),
      // exampleRoute: (context) => DropdownListPage(),
      shiftClockInOutRoute: (context) => ShiftDetailsView(),
      // shiftDetailsMainRoute: (context) => ShiftDetailsPage(),
      // mapSampleRoute: (context) => MapSample(),
      // staffDetailsFormRoute: (context) => StaffDetailsFormView(),
    };
  }
}
