import 'dart:io';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../../../config/constants/app_sizes.dart';
import '../../../../../config/constants/image_strings.dart';
import '../../../../../config/constants/text_strings.dart';
import '../../../../../config/router/app_routes.dart';
import '../../../../../core/common/styles/spacing_styles.dart';

import '../../../../../core/utils/validators/validators.dart';
import '../../../../core/common/provider/connection.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../../core/utils/helpers/permission_helper.dart';
import '../auth_viewmodel/auth_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool isObscure = true;
  bool isDarkModeDialogShown = false;
  late SharedPreferences preferences;
  final _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool? rememberMe = false;
  bool isSnackbarShown = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  String? versionName;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();

    _loadSavedUsername();
    _checkBiometricAvailability();
    setState(() {});
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();
    setState(() {
      _isBiometricAvailable = canCheckBiometrics;
      _availableBiometrics = availableBiometrics;
    });
  }

  String _getBiometricButtonText() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Login with Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Login with Fingerprint';
    } else {
      return 'Biometric Authentication';
    }
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
      );
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }

    if (isAuthenticated) {
      EasyLoading.show(status: 'Authenticating...');
      await ref.read(authViewModelProvider.notifier).loginUser(
            _usernameController.text,
            _passwordController.text,
            context,
          );
    }
  }

  void _onRememberMeChanged(bool newValue) async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = newValue;
      if (rememberMe!) {
        if (_usernameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          preferences.setBool("REMEMBER_ME", true);
          preferences.setString("Username", _usernameController.text);
        }
      } else {
        preferences.setBool('REMEMBER_ME', false);
        preferences.remove("Username");
      }
    });
  }

  void _loadSavedUsername() async {
    preferences = await SharedPreferences.getInstance();
    final savedUsername = preferences.getString("Username");
    if (savedUsername != null) {
      setState(() {
        _usernameController.text = savedUsername;
      });
    }
  }

  Future<void> _requestPermissions() async {
    await PermissionHelper.requestLocationPermission(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Consumer(builder: (context, watch, child) {
      final connectivityStatus = ref.watch(connectivityStatusProvider);

      // Check the internet connectivity
      switch (connectivityStatus) {
        case ConnectivityStatus.isConnected:
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: dark ? Colors.black : Colors.white,
          ));
          break;
        case ConnectivityStatus.isDisconnected:
          if (!isSnackbarShown) {
            isSnackbarShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: AppColors.error,
              ));
              showSnackBar(
                context: context,
                message: AppTexts.noInternet,
                color: AppColors.error,
              );
            });
          }
          break;
        case ConnectivityStatus.isConnecting:
          break;
        case ConnectivityStatus.notDetermined:
          break;
      }

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: dark ? AppColors.dark : Colors.white,
        ),
        child: Scaffold(
          backgroundColor: dark ? AppColors.dark : AppColors.whiteText,
          appBar: AppBar(
            backgroundColor: dark ? AppColors.dark : AppColors.whiteText,
            toolbarHeight: 40,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: dark ? AppColors.whiteText : AppColors.primaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.preloginRoute);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: AppSpacingStyle.paddingWithAppBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //Logo
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image(
                          height: 150,
                          image: AssetImage(
                            dark
                                ? AppImages.darkAppLogo
                                : AppImages.lightAppLogo,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      Text(
                        AppTexts.loginPageTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        AppTexts.loginPageSubTitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceBtwnInputFields),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceBtwSections,
                      ),
                      child: Column(
                        children: [
                          //Username
                          TextFormField(
                            key: const ValueKey('username'),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: AppTexts.username,
                              hintText: AppTexts.usernamehint,
                            ),
                            validator: (value) {
                              final error =
                                  AppValidator.validateUsername(value);
                              return error;
                            },
                          ),
                          const SizedBox(height: AppSizes.spaceBtwnInputFields),
                          //Password
                          TextFormField(
                            key: const ValueKey('password'),
                            controller: _passwordController,
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.password_check),
                              labelText: AppTexts.password,
                              hintText: AppTexts.passwordHint,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure ? Iconsax.eye : Iconsax.eye_slash,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                            ),
                            // validator: (value) {
                            //   final error =
                            //       AppValidator.validatePassword(value);
                            //   return error;
                            // },
                          ),
                          const SizedBox(
                              height: AppSizes.spaceBtwnInputFields / 2),

                          //Remeber Me and Forget Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: rememberMe ?? false,
                                onChanged: (value) {
                                  _onRememberMeChanged(value!);
                                },
                              ),
                              Text(
                                AppTexts.remeberme,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, MyRoutes.sendOTPRoute);
                                },
                                child: Text(
                                  AppTexts.forgetPassword,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: AppSizes.spaceBtwSections),
                          if (Platform.isAndroid && _isBiometricAvailable)
                            ElevatedButton(
                              onPressed: _authenticateUser,
                              child:
                                  const Text('Login with Biometrics (Android)'),
                            ),
                          if (Platform.isIOS && _isBiometricAvailable)
                            ElevatedButton(
                              onPressed: _authenticateUser,
                              child: const Text('Login with Biometrics (iOS)'),
                            ),
                          //Sign in Button
                          Hero(
                            tag: 'loginbutton',
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                key: const ValueKey('loginbutton'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    await ref
                                        .read(authViewModelProvider.notifier)
                                        .loginUser(
                                          _usernameController.text,
                                          _passwordController.text,
                                          context,
                                        );
                                  }
                                },
                                child: Text(AppTexts.login.toUpperCase()),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwSections,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
