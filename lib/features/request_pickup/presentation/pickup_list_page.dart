import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isdark = HelperFunctions.isDarkMode(context);
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
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pickup = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: isdark ? AppColors.cardDarkMode : AppColors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: isdark ? AppColors.white : AppColors.primaryColor,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
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
                        SizedBox(height: 5),
                        Text(
                          pickup.address,
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${localizations.translate('date')}: ${pickup.date} ${localizations.translate('time')}: ${pickup.time}',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${localizations.translate('phone')}: ${pickup.phoneNumber}',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
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
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
