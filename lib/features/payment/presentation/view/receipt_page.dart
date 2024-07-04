import 'package:flutter/material.dart';
import 'package:foharmalai/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../app_localizations.dart';
import '../../../../core/common/widgets/torn_paper.dart';

class ReceiptPage extends StatelessWidget {
  final String amount;
  final String receiverKhaltiNumber;
  final String purpose;

  ReceiptPage({
    required this.amount,
    required this.receiverKhaltiNumber,
    required this.purpose,
  });

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _downloadReceipt(BuildContext context) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/receipt.png';
    screenshotController
        .captureAndSave(directory, fileName: 'receipt.png')
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt saved to $path')),
      );
    });
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
      body: CustomPaint(
        painter: TornPaperPainter(),
        child: Screenshot(
          controller: screenshotController,
          child: Padding(
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
                        size: 80.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        localization.translate('paymentSuccessful'),
                        style: GoogleFonts.montserrat(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        localization.translate('thankYou'),
                        style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        localization.translate('dearCustomer'),
                        style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0),
                Text(
                  localization.translate('transactionDetails'),
                  style: GoogleFonts.montserrat(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Divider(color: Colors.grey),
                _buildDetailRow(
                  context,
                  icon: Icons.attach_money,
                  label: localization.translate('amount'),
                  value: 'Rs. $amount',
                ),
                Divider(color: Colors.grey),
                _buildDetailRow(
                  context,
                  icon: Icons.phone_android,
                  label: localization.translate('receiverKhaltiNumber'),
                  value: receiverKhaltiNumber,
                ),
                Divider(color: Colors.grey),
                _buildDetailRow(
                  context,
                  icon: Icons.description,
                  label: localization.translate('purpose'),
                  value: purpose,
                ),
                Divider(color: Colors.grey),
                _buildDetailRow(
                  context,
                  icon: Icons.payment,
                  label: localization.translate('paymentMode'),
                  value: localization.translate('online'),
                ),
                Divider(color: Colors.grey),
                _buildDetailRow(
                  context,
                  icon: Icons.check_circle,
                  label: localization.translate('status'),
                  value: localization.translate('success'),
                ),
                Divider(color: Colors.grey),
                Spacer(),
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
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Handle report a dispute action
                    },
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

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
