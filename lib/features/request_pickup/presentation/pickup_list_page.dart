import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
                return Card(
                  color: isDarkMode ? AppColors.cardDarkMode : Colors.white,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
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
                        Row(
                          children: [
                            Icon(Iconsax.location,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pickup.address,
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Iconsax.calendar,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.translate('date')}: ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: pickup.date,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' ${localizations.translate('time')}: ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: pickup.time,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Iconsax.call,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.translate('phone')}: ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: pickup.phoneNumber,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
}

Future<String?> getUserId() async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? userId = await secureStorage.read(key: 'userId');
  print("Retrieved userId from secure storage: $userId");
  return userId;
}
