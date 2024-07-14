import 'package:foharmalai/features/drop_points/drop_points_view.dart';
import 'package:foharmalai/features/forgot_password/forgot_password_view.dart';
import 'package:foharmalai/features/payment/presentation/view/transaction_history_page.dart';
import 'package:foharmalai/features/request_pickup/presentation/pickup_list_page.dart';

import '../../features/auth/presentation/view/login_page.dart';
import '../../features/auth/presentation/view/register_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/payment/presentation/esewa_load.dart';
import '../../features/payment/presentation/view/khalti_load.dart';
import '../../features/payment/presentation/view/payments_view.dart';
import '../../features/prelogin/presentation/view/pre_login_view.dart';
import '../../features/request_pickup/presentation/request_pickup_page.dart';
import '../../features/special_requests/presentation/view/create_special_requests_view.dart';
import '../../features/splash_screen/splash_screen_view.dart';
import '../../features/what_we_buy/view/what_we_buy_page.dart';

class MyRoutes {
  MyRoutes._();

  static const String splashRoute = '/splash';
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
  static String loadEsewaRoute = '/loadEsewaRoute';
  static String loadKhaltiRoute = "/loadKhaltiRoute";
  static String requestPickupRoute = '/requestPickupRoute';
  static String pickUpListRoute = '/pickupListRoute';
  static String specialRequestRoute = '/specialRequestRoute';
  static String statementRoute = '/statementRoute';
  static String dropPointRoutes = '/dropPointRoute';
  static String forgotPasswordRoute = '/forgotPassword';

  static getApplicationRoute() {
    return {
      // // homeRoute: (context) => HomePage(),
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => RegisterView(),
      whatWeBuyRoute: (context) => WhatWeBuyPage(),
      splashRoute: (context) => SplashScreen(),
      // onBoardingRoute: (context) => OnBoardingScreen(),
      preloginRoute: (context) => const PreLoginPage(),
      // userProfileRoute: (context) => StaffProfile(),
      // // viewNotificationRoute: (context) => NotificationView(),
      // // sendOTPRoute: (context) => SendOTPView(),
      // // verifyOTPRoute: (context) => VerifyOTPPage(),
      homePageRoute: (context) => HomePageNew(),
      loadEsewaRoute: (context) => LoadToEsewaPage(),
      paymentRoute: (context) => PaymentPage(),
      loadKhaltiRoute: (context) => LoadToKhaltiPage(),
      requestPickupRoute: (context) => RequestPickUpView(),
      pickUpListRoute: (context) => PickupListPage(),
      specialRequestRoute: (context) => SpecialRequestsPage(),
      statementRoute: (context) => TransactionHistoryPage(),
      dropPointRoutes: (context) => SelfServiceDropPointsView(),
      forgotPasswordRoute: (context) => ForgotPasswordPage(),
    };
  }
}
