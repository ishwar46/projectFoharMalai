import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../config/router/app_routes.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../domain/use_case/login_usecase.dart';
import '../state/state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(ref.read(loginUseCaseProvider)),
);

class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthViewModel(this._loginUseCase) : super(AuthState.initial());

  // Login Staff
  Future<void> loginUser(
      String username, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final result = await _loginUseCase.loginUser(username, password);
    state = state.copyWith(isLoading: false);

    result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.error,
          showMessage: true,
        );
        showSnackBar(
          message: failure.error,
          context: context,
          color: AppColors.error,
        );
      },
      (success) {
        if (success) {
          EasyLoading.show(
            status: 'Please wait...',
            maskType: EasyLoadingMaskType.black,
          );
          Future.delayed(const Duration(seconds: 2), () {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'User logged in successfully',
              context: context,
              color: AppColors.success,
            );
            Navigator.pushReplacementNamed(context, MyRoutes.homePageRoute);
          });
        } else {
          showSnackBar(
            message: 'Login failed. Please try again.',
            context: context,
            color: AppColors.error,
          );
        }
      },
    );
  }

  void reset() {
    state = state.copyWith(
      isLoading: false,
      error: null,
      imageName: null,
      showMessage: false,
    );
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: value);
  }
}
