import 'package:flutter/material.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:foharmalai/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart';
import '../../../../app_localizations.dart';
import 'transaction_history_page.dart';

class ReceiptPage extends StatelessWidget {
  final String amount;
  final String receiverPhoneNumber;
  final String purpose;
  final String transactionId;
  final String transactionDate;
  final String transactionTime;

  ReceiptPage({
    required this.amount,
    required this.receiverPhoneNumber,
    required this.purpose,
    required this.transactionId,
    required this.transactionDate,
    required this.transactionTime,
  });

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _downloadReceipt(BuildContext context) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/receipt.png';
    screenshotController
        .captureAndSave(directory, fileName: 'receipt.png')
        .then((value) {
      showSnackBar(message: 'Receipt saved to $path', context: context);
    });
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar(
        message: 'Transaction ID copied to clipboard', context: context);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('receipt')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _downloadReceipt(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.grey[200]!],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            ),
        child: Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        localization.translate('paymentSuccessful'),
                        style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        localization
                            .translate('thankYouMessage')
                            .replaceAll('{amount}', amount)
                            .replaceAll('{receiver}', receiverPhoneNumber),
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  localization.translate('transactionDetails'),
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildDetailCard(
                  context,
                  icon: Icons.attach_money,
                  label: localization.translate('amount'),
                  value: 'Rs. $amount',
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.phone_android,
                  label: localization.translate('receiverKhaltiNumber'),
                  value: receiverPhoneNumber,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.description,
                  label: localization.translate('purpose'),
                  value: purpose,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.payment,
                  label: localization.translate('paymentMode'),
                  value: localization.translate('online'),
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.check_circle,
                  label: localization.translate('status'),
                  value: localization.translate('success'),
                  valueColor: Colors.green,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.date_range,
                  label: localization.translate('date'),
                  value: transactionDate,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.access_time,
                  label: localization.translate('time'),
                  value: transactionTime,
                ),
                GestureDetector(
                  onTap: () => _copyToClipboard(context, transactionId),
                  child: _buildDetailCard(
                    context,
                    icon: Icons.receipt_long,
                    label: localization.translate('transactionId'),
                    value: transactionId,
                    isCopyable: true,
                  ),
                ),
                SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardView()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      localization.translate('goToDashboard'),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(),
                      ),
                    );
                  },
                  child: Text(localization.translate('viewTransactionHistory')),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      localization.translate('reportDispute'),
                      style: GoogleFonts.montserrat(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isCopyable = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 1.0,
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20.0,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black,
                  ),
                ),
                if (isCopyable)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.copy,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
