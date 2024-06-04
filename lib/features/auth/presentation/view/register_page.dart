import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../../../config/constants/app_sizes.dart';
import '../../../../../config/constants/image_strings.dart';
import '../../../../../config/router/app_routes.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../app_localizations.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../auth_viewmodel/auth_viewmodel.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  bool isObscure = true;
  bool isDarkModeDialogShown = false;
  final _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
  final _gap = SizedBox(
    height: AppSizes.spaceBtwnInputFields,
  );

  bool? rememberMe = false;
  bool isSnackbarShown = false;

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Consumer(builder: (context, watch, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: dark ? AppColors.dark : Colors.white,
        ),
        child: Scaffold(
          backgroundColor: dark ? AppColors.dark : AppColors.whiteText,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //Logo
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Hero(
                          tag: 'logo',
                          child: Image(
                            height: 200,
                            image: AssetImage(
                              dark
                                  ? AppImages.darkAppLogo
                                  : AppImages.lightAppLogo,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtnCards,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('register'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        AppLocalizations.of(context)
                            .translate('register_page_title'),
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
                          //fullname
                          TextFormField(
                            key: const ValueKey('fullname'),
                            controller: _fullnameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.account),
                              labelText: AppLocalizations.of(context)
                                  .translate('fullname'),
                              hintText: AppLocalizations.of(context)
                                  .translate('fullname_hint'),
                            ),
                            validator: (value) {
                              final error =
                                  AppValidator.validateFullName(value);
                              return error;
                            },
                          ),
                          _gap,
                          //email
                          TextFormField(
                            key: const ValueKey('email'),
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.email),
                              labelText: AppLocalizations.of(context)
                                  .translate('email'),
                              hintText: AppLocalizations.of(context)
                                  .translate('email_hint'),
                            ),
                          ),
                          _gap,
                          //address
                          GooglePlacesAutoCompleteTextFormField(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('address'),
                              hintText: AppLocalizations.of(context)
                                  .translate('address_hint'),
                              prefixIcon: Icon(MdiIcons.mapMarker),
                            ),
                            textEditingController: _addressController,
                            googleAPIKey: apiKey ?? 'NA',
                            debounceTime: 400,
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (prediction) {
                              print(
                                  "Coordinates: (${prediction.lat},${prediction.lng})");
                            },
                            itmClick: (prediction) {
                              if (prediction.description != null) {
                                _addressController.text =
                                    prediction.description!;
                                _addressController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: prediction.description!.length),
                                );
                              } else {
                                _addressController.clear();
                              }
                            },
                          ),
                          _gap,
                          //Username
                          TextFormField(
                            key: const ValueKey('username'),
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.account),
                              labelText: AppLocalizations.of(context)
                                  .translate('username'),
                              hintText: AppLocalizations.of(context)
                                  .translate('username_hint'),
                            ),
                            validator: (value) {
                              final error =
                                  AppValidator.validateUsername(value);
                              return error;
                            },
                          ),
                          _gap,
                          //Password
                          TextFormField(
                            key: const ValueKey('password'),
                            controller: _passwordController,
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.lock),
                              labelText: AppLocalizations.of(context)
                                  .translate('password'),
                              hintText: AppLocalizations.of(context)
                                  .translate('password_hint'),
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
                            validator: (value) {
                              final error =
                                  AppValidator.validatePassword(value);
                              return error;
                            },
                          ),
                          const SizedBox(height: AppSizes.spaceBtwSections),
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
                                child: Text(AppLocalizations.of(context)
                                    .translate('register')
                                    .toUpperCase()),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwSections,
                          ),
                          InkWell(
                            key: const ValueKey('loginButton'),
                            onTap: () {
                              Navigator.pushNamed(context, MyRoutes.loginRoute);
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('already_have_account'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: dark
                                          ? AppColors.whiteText
                                          : AppColors.buttonPrimary,
                                      fontWeight: FontWeight.w600),
                            ),
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
