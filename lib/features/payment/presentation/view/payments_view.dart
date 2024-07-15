import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app_localizations.dart';
import '../../../../core/common/widgets/balance_error.dart';
import '../../../../core/common/widgets/balance_loading_shimmer.dart';
import '../../../home/model/user_model.dart';
import '../../../home/service/user_service.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isBalanceVisible = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = UserService().getUserProfile();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _onPaymentOptionTap(String option) {
    switch (option) {
      case 'eSewa':
        showSnackBar(
            message: 'Esewa is coming soon! Stay Tuned.',
            context: context,
            color: AppColors.error);
        break;
      case 'Khalti':
        Navigator.pushNamed(context, '/loadKhaltiRoute');
        break;
      case 'IMEPay':
        showSnackBar(
            message: 'IME Pay is coming soon! Stay Tuned.',
            context: context,
            color: AppColors.error);
        break;
    }
  }

  void _scanQRCode() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('payments')),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: FutureBuilder<User>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: BalanceLoadingShimmer());
                  } else if (snapshot.hasError) {
                    return BalanceErrorWidget(
                      errorMessage: 'Error Loading Balance',
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("No data found"));
                  }

                  User user = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isBalanceVisible
                                ? 'Rs. ${user.balance!.toStringAsFixed(2)}'
                                : 'Rs. XXX.XX',
                            style: GoogleFonts.roboto(
                              color: AppColors.whiteText,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            localization.translate('availableBalance'),
                            style: GoogleFonts.roboto(
                              color: AppColors.whiteText,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isBalanceVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.whiteText,
                            ),
                            onPressed: _toggleBalanceVisibility,
                          ),
                          Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.whiteText,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              localization.translate('paymentOptions'),
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _onPaymentOptionTap('Khalti'),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/e/ee/Khalti_Digital_Wallet_Logo.png.jpg',
                    height: 50.0,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline_outlined),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onPaymentOptionTap('eSewa'),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://cdn.esewa.com.np/ui/images/esewa_og.png?111',
                    height: 50.0,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline_outlined),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onPaymentOptionTap('IMEPay'),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://play-lh.googleusercontent.com/LzKjYKvzLnyMq9XaRm3RauNI-ni7QwuN4r_IzClSXUNpO6o443SDACRd92ePn03UNHU',
                    height: 50.0,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline_outlined),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _scanQRCode,
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 60.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    localization.translate('scanToPay'),
                    style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
