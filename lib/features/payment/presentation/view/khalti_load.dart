import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import '../../../../app_localizations.dart';
import '../../../home/model/user_model.dart';
import '../../../home/service/user_service.dart';
import '../../model/transaction_model.dart';
import 'receipt_page.dart';

class LoadToKhaltiPage extends StatefulWidget {
  @override
  _LoadToKhaltiPageState createState() => _LoadToKhaltiPageState();
}

class _LoadToKhaltiPageState extends State<LoadToKhaltiPage> {
  bool _isBalanceVisible = true;
  final _amountController = TextEditingController();
  final _receiverPhoneNumberController = TextEditingController();
  final _purposeController = TextEditingController();
  final ValueNotifier<bool> _isSubmitButtonEnabled = ValueNotifier<bool>(false);
  late Future<User> userFuture;
  late Future<List<Transaction>> transactionsFuture;

  @override
  void initState() {
    super.initState();
    userFuture = UserService().getUserProfile();
    transactionsFuture = UserService().getUserTransactions();
    _amountController.addListener(_updateSubmitButtonState);
    _receiverPhoneNumberController.addListener(_updateSubmitButtonState);
    _purposeController.addListener(_updateSubmitButtonState);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _receiverPhoneNumberController.dispose();
    _purposeController.dispose();
    _isSubmitButtonEnabled.dispose();
    super.dispose();
  }

  void _updateSubmitButtonState() {
    final isButtonEnabled = _amountController.text.isNotEmpty &&
        _receiverPhoneNumberController.text.isNotEmpty &&
        _purposeController.text.isNotEmpty;
    _isSubmitButtonEnabled.value = isButtonEnabled;
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  Future<void> _pickContact() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null &&
          contact.phones != null &&
          contact.phones!.isNotEmpty) {
        setState(() {
          _receiverPhoneNumberController.text =
              contact.phones!.first.value ?? '';
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.permanentlyDenied) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }

  void _handleInvalidPermissions(PermissionStatus status) {
    if (status == PermissionStatus.denied) {
      // Handle denied permission
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied permission
    }
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final amount = _amountController.text;
    final receiverPhoneNumber = _receiverPhoneNumberController.text;
    final purpose = _purposeController.text;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.translate('confirmation'),
                style: GoogleFonts.roboto(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                localization.translate('confirmPaymentDetails'),
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: AppColors.white,
                surfaceTintColor: AppColors.white,
                elevation: 1.0,
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConfirmationDetail(
                        context,
                        label: localization.translate('amount'),
                        value: amount,
                      ),
                      Divider(),
                      _buildConfirmationDetail(
                        context,
                        label: localization.translate('receiverPhoneNumber'),
                        value: receiverPhoneNumber,
                      ),
                      Divider(),
                      _buildConfirmationDetail(
                        context,
                        label: localization.translate('purpose'),
                        value: purpose,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _makePayment(amount, receiverPhoneNumber, purpose);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    localization.translate('confirm'),
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
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

  Widget _buildConfirmationDetail(BuildContext context,
      {required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.0,
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _makePayment(
      String amount, String receiverPhoneNumber, String purpose) async {
    final localization = AppLocalizations.of(context);
    try {
      final success = await UserService().makePayment(
        int.parse(amount),
        receiverPhoneNumber,
        purpose,
      );
      if (success) {
        showSnackBar(
            message: localization.translate('payment_successful'),
            context: context);
        _showReceiptPage(context, amount, receiverPhoneNumber, purpose);
      } else {
        showSnackBar(
            message: localization.translate('payment_failed'),
            context: context,
            color: AppColors.error);
      }
    } catch (e) {
      showSnackBar(
          message: '${localization.translate('error')}: $e',
          context: context,
          color: AppColors.error);
    }
  }

  void _showReceiptPage(BuildContext context, String amount,
      String receiverPhoneNumber, String purpose) {
    final transactionId = 'FMTX-${DateTime.now().millisecondsSinceEpoch}';
    final transactionDateTime = DateTime.now();
    final transactionDate =
        '${transactionDateTime.year}-${transactionDateTime.month}-${transactionDateTime.day}';
    final transactionTime =
        '${transactionDateTime.hour}:${transactionDateTime.minute}:${transactionDateTime.second}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          amount: amount,
          receiverPhoneNumber: receiverPhoneNumber,
          purpose: purpose,
          transactionId: transactionId,
          transactionDate: transactionDate,
          transactionTime: transactionTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.translate('loadToKhalti'),
          style: GoogleFonts.roboto(),
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
              child: FutureBuilder<User>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
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
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: localization.translate('amount'),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _receiverPhoneNumberController,
              decoration: InputDecoration(
                labelText: localization.translate('receiverPhoneNumber'),
                suffixIcon: IconButton(
                  icon: Icon(Icons.contacts),
                  onPressed: _pickContact,
                ),
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
            ValueListenableBuilder<bool>(
              valueListenable: _isSubmitButtonEnabled,
              builder: (context, isEnabled, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            _showConfirmationBottomSheet(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      localization.translate('submit'),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
