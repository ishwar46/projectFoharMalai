import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import '../../../home/service/user_service.dart';
import '../../model/transaction_model.dart';
import '../../../../app_localizations.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<Transaction>> transactionsFuture;

  @override
  void initState() {
    super.initState();
    transactionsFuture = UserService().getUserTransactions();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('transactionHistory')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Transaction>>(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(localization.translate('noTransactionsFound')));
          }

          List<Transaction> transactions = snapshot.data!;
          Map<String, List<Transaction>> groupedTransactions = {};

          for (var transaction in transactions) {
            String dateKey = formatDate(transaction.date);
            if (!groupedTransactions.containsKey(dateKey)) {
              groupedTransactions[dateKey] = [];
            }
            groupedTransactions[dateKey]!.add(transaction);
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: groupedTransactions.keys.length,
            itemBuilder: (context, index) {
              String dateKey = groupedTransactions.keys.elementAt(index);
              List<Transaction> transactionsByDate =
                  groupedTransactions[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateKey,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ...transactionsByDate.map((transaction) {
                    bool isCredit = transaction.type == 'credit';
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${transaction.amount}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${transaction.id}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Purpose: ${transaction.purpose ?? 'N/A'}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Date: ${formatDateTime(transaction.date)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Receiver: ${transaction.receiverPhoneNumber ?? 'N/A'}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              // Text(
                              //   'Opening Balance: Rs. ${transaction.openingBalance}',
                              //   style: GoogleFonts.roboto(
                              //     fontSize: 14.0,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              // SizedBox(height: 4.0),
                              // Text(
                              //   'Closing Balance: Rs. ${transaction.closingBalance}',
                              //   style: GoogleFonts.roboto(
                              //     fontSize: 14.0,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: isCredit ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              isCredit ? 'CREDIT' : 'DEBIT',
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
