import 'package:flutter/material.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
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
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      transactionsFuture = UserService().getUserTransactions();
    });
  }

  DateTime convertToNepalTime(DateTime dateTime) {
    final nepalTime = tz.getLocation('Asia/Kathmandu');
    return tz.TZDateTime.from(dateTime, nepalTime);
  }

  String formatDateTime(DateTime dateTime) {
    DateTime nepalDateTime = convertToNepalTime(dateTime);
    return DateFormat('MMM dd, yyyy – hh:mm a').format(nepalDateTime);
  }

  String formatDate(DateTime dateTime) {
    DateTime nepalDateTime = convertToNepalTime(dateTime);
    final now = DateTime.now();
    final nepalNow = convertToNepalTime(now);

    if (nepalDateTime.year == nepalNow.year &&
        nepalDateTime.month == nepalNow.month &&
        nepalDateTime.day == nepalNow.day) {
      return 'Today';
    } else if (nepalDateTime.year == nepalNow.year &&
        nepalDateTime.month == nepalNow.month &&
        nepalDateTime.day == nepalNow.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(nepalDateTime);
    }
  }

  void _pickDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 1);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : DateTimeRange(start: now.subtract(Duration(days: 7)), end: now),
    );

    if (picked != null &&
        picked != DateTimeRange(start: fromDate!, end: toDate!)) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
        fetchTransactions();
      });
    }
  }

  void _filterTransactionsByPresetPeriod(int days) {
    setState(() {
      fromDate = DateTime.now().subtract(Duration(days: days));
      toDate = DateTime.now();
      fetchTransactions();
    });
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (fromDate == null && toDate == null) {
      return transactions;
    }
    return transactions.where((transaction) {
      final transactionDate = transaction.date;
      if (fromDate != null && transactionDate.isBefore(fromDate!)) {
        return false;
      }
      if (toDate != null && transactionDate.isAfter(toDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final isDark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('statements')),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTransactions,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickDateRange(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        backgroundColor: isDark
                            ? Colors.blueGrey[800]
                            : AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Icon(Iconsax.calendar_1, color: Colors.white),
                      label: Text(
                        localization.translate('pickDateRange'),
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _filterTransactionsByPresetPeriod(7),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        backgroundColor: isDark
                            ? Colors.blueGrey[800]
                            : AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Icon(Iconsax.calendar_remove, color: Colors.white),
                      label: Text(
                        localization.translate('1Week'),
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _filterTransactionsByPresetPeriod(30),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        backgroundColor: isDark
                            ? Colors.blueGrey[800]
                            : AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Icon(Iconsax.calendar, color: Colors.white),
                      label: Text(
                        localization.translate('1Month'),
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Transaction>>(
                future: transactionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                            localization.translate('noTransactionsFound')));
                  }

                  List<Transaction> transactions =
                      _filterTransactions(snapshot.data!);
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
                      String dateKey =
                          groupedTransactions.keys.elementAt(index);
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
                                    gradient: isDark
                                        ? LinearGradient(
                                            colors: [
                                              AppColors.darkModeOnPrimary,
                                              AppColors.dark
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          )
                                        : LinearGradient(
                                            colors: [
                                              AppColors.white,
                                              AppColors.white
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    color:
                                        isDark ? null : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDark
                                            ? Colors.black54
                                            : Colors.grey.shade300,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'TID: ${transaction.id}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Purpose: ${transaction.purpose ?? 'N/A'}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.0,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Date & Time: ${formatDateTime(transaction.date)}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.0,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Receiver: ${transaction.receiverPhoneNumber ?? 'N/A'}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.0,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
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
                                      color:
                                          isCredit ? Colors.green : Colors.red,
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
            ),
          ],
        ),
      ),
    );
  }
}
