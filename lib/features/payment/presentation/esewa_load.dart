import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_localizations.dart';

class LoadToEsewaPage extends StatefulWidget {
  @override
  _LoadToEsewaPageState createState() => _LoadToEsewaPageState();
}

class _LoadToEsewaPageState extends State<LoadToEsewaPage> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('loadToEsewa')),
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        localization.translate('availableBalance'),
                        style: GoogleFonts.montserrat(
                          color: AppColors.whiteText,
                          fontSize: 16.0,
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
              decoration: InputDecoration(
                labelText: localization.translate('amount'),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: localization.translate('receiverEsewaNumber'),
                suffixIcon: Icon(Icons.contacts),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: localization.translate('purpose'),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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
