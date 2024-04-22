import 'package:care_app_flutter/features/shift_details/presentation/view/shift_details_new.dart';
import 'package:care_app_flutter/features/user_details/presentation/view/staff_details_form_view.dart';
import 'package:care_app_flutter/features/user_information/presentation/widgets/maptest.dart';

import '../../features/auth/presentation/view/login_page.dart';
import '../../features/dashboard/presentation/view/dashboard_view.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/onboarding/presentation/views/onboarding_screens.dart';
import '../../features/prelogin/presentation/view/pre_login_view.dart';
import '../../features/profile/presentation/view/my_profile.dart';
import '../../features/shift_details/presentation/view/bottomview/shift_details_view.dart';
import '../../features/shift_details/presentation/view/bottomview/tasks_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../../features/user_information/presentation/widgets/testtt.dart';

class MyRoutes {
  MyRoutes._();

  static const String splashRoute = '/splash';
  static String homeRoute = "/home";
  static String loginRoute = "/loginpage";
  static String signupRoute = "/registerpage";
  static String appointmentsRoute = "/appointmentspage";
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
  static String userInformationRoute = "/userInformation";
  static String exampleRoute = '/exampleRoute';
  static String shiftClockInOutRoute = '/shiftClockInOutRoute';
  static String shiftDetailsMainRoute = '/shiftDetailsMainRoute';
  static String mapSampleRoute = '/MapSample';
  static String taskViewRoute = '/tasksViewRoute';
  static String staffDetailsFormRoute = '/staffDetailsFormRoute';

  static getApplicationRoute() {
    return {
      // homeRoute: (context) => HomePage(),
      loginRoute: (context) => LoginView(),
      // signupRoute: (context) => RegisterView(),
      // appointmentsRoute: (context) => AppointmentView(),
      splashRoute: (context) => SplashScreen(),
      onBoardingRoute: (context) => OnBoardingScreen(),
      // staffDetailsRoute: (context) => AddStaffView(),
      preloginRoute: (context) => PreLoginPage(),
      // viewbookedappointment: (context) => ViewBookedAppointments(),
      // settingsRoute: (context) => SettingsView(),
      userProfileRoute: (context) => StaffProfile(),
      // viewNotificationRoute: (context) => NotificationView(),
      // sendOTPRoute: (context) => SendOTPView(),
      // verifyOTPRoute: (context) => VerifyOTPPage(),
      homePageRoute: (context) => HomePageNew(),
      // qrCodeRoute: (context) => QRCodeView(),
      // paymentRoute: (context) => Payment(),
      // clientRoute: (context) => StaffViewNew(),
      taskViewRoute: (context) => TasksView(),
      dashboardRoute: (context) => DashboardView(),
      //userInformationRoute: (context) => UserInformationView(),
      userInformationRoute: (context) => StaffProfile(),
      exampleRoute: (context) => DropdownListPage(),
      shiftClockInOutRoute: (context) => ShiftDetailsView(),
      shiftDetailsMainRoute: (context) => ShiftDetailsPage(),
      mapSampleRoute: (context) => MapSample(),
      staffDetailsFormRoute: (context) => StaffDetailsFormView(),
    };
  }
}
