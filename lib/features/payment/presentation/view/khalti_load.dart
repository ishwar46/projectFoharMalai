import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import '../../../../app_localizations.dart';
import 'receipt_page.dart';

class LoadToKhaltiPage extends StatefulWidget {
  @override
  _LoadToKhaltiPageState createState() => _LoadToKhaltiPageState();
}

class _LoadToKhaltiPageState extends State<LoadToKhaltiPage> {
  bool _isBalanceVisible = true;
  final _amountController = TextEditingController();
  final _receiverKhaltiNumberController = TextEditingController();
  final _purposeController = TextEditingController();

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final amount = _amountController.text;
    final receiverKhaltiNumber = _receiverKhaltiNumberController.text;
    final purpose = _purposeController.text;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.translate('confirmation'),
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(localization.translate('confirmPaymentDetails')),
              SizedBox(height: 16.0),
              Text('${localization.translate('amount')}: $amount'),
              Text(
                  '${localization.translate('receiverKhaltiNumber')}: $receiverKhaltiNumber'),
              Text('${localization.translate('purpose')}: $purpose'),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showReceiptPage(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    localization.translate('confirm'),
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReceiptPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          amount: _amountController.text,
          receiverKhaltiNumber: _receiverKhaltiNumberController.text,
          purpose: _purposeController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('loadToKhalti')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isBalanceVisible ? 'Rs. XXX.XX' : 'Rs. 13579.55',
                        style: GoogleFonts.montserrat(
                          color: AppColors.whiteText,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        localization.translate('availableBalance'),
                        style: GoogleFonts.montserrat(
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
              ),
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: localization.translate('amount'),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _receiverKhaltiNumberController,
              decoration: InputDecoration(
                labelText: localization.translate('receiverKhaltiNumber'),
                suffixIcon: Icon(Icons.contacts),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _purposeController,
              decoration: InputDecoration(
                labelText: localization.translate('purpose'),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  localization.translate('submit'),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
