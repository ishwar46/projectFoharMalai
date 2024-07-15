import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:lottie/lottie.dart';

class PaymentProcessingDialog extends StatelessWidget {
  final String message;
  final ValueNotifier<bool> isProcessing;

  const PaymentProcessingDialog(
      {Key? key, required this.message, required this.isProcessing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isProcessing,
      builder: (context, isProcessing, child) {
        if (!isProcessing) {
          Navigator.pop(context); // Close the dialog when no longer processing
        }
        return Dialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isProcessing)
                  Lottie.asset('assets/animations/payment_processing.json',
                      height: 150),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
