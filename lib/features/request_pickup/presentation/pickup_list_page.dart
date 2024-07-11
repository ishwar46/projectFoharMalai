import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app_localizations.dart';
import '../data/pickup_service.dart';
import '../model/PickupRequest.dart';

class PickupListPage extends StatefulWidget {
  @override
  _PickupListPageState createState() => _PickupListPageState();
}

class _PickupListPageState extends State<PickupListPage> {
  final PickupService _pickupService = PickupService();
  late Future<List<PickupRequest>> _futurePickups;

  @override
  void initState() {
    super.initState();
    _futurePickups = _loadPickupRequests();
  }

  Future<List<PickupRequest>> _loadPickupRequests() async {
    String? userId = await getUserId();
    return _pickupService.getPickupsByUserIdOrSessionId(userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('my_requests'),
            style: GoogleFonts.roboto()),
      ),
      body: FutureBuilder<List<PickupRequest>>(
        future: _futurePickups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${localizations.translate('error')}: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pickup = snapshot.data![index];
                return buildPickupCard(
                    context, pickup, localizations, isDarkMode);
              },
            );
          } else {
            return Center(
                child: Text(localizations.translate('no_pickups_found'),
                    style: GoogleFonts.roboto()));
          }
        },
      ),
    );
  }

  Widget buildPickupCard(BuildContext context, PickupRequest pickup,
      AppLocalizations localizations, bool isDarkMode) {
    final pickupDate = DateTime.parse(pickup.date);
    final day = pickupDate.day.toString();
    final month = DateFormat('MMM').format(pickupDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkMode : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.white : AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        month,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup.fullName,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildIconText(
                        Iconsax.location,
                        '${localizations.translate('address')}: ${pickup.address}',
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildIconText(
                        Iconsax.clock,
                        '${localizations.translate('time')}: ${pickup.time}',
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildIconText(
                        Iconsax.calendar,
                        '${localizations.translate('date')}: ${pickup.date}',
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildIconText(
                        Iconsax.call,
                        '${localizations.translate('phone')}: ${pickup.phoneNumber}',
                        isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconText(IconData icon, String text, bool isDarkMode) {
    List<String> parts = text.split(
        ': '); // Split the text by the colon to separate the key and value
    return Row(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Align items at the start in case text wraps
      children: [
        Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          // Use Expanded to allow text to fill the row
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${parts[0]}: ', // Key part
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextSpan(
                  text: parts.length > 1 ? parts[1] : '', // Value part
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<String?> getUserId() async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? userId = await secureStorage.read(key: 'userId');
  print("Retrieved userId from secure storage: $userId");
  return userId;
}
