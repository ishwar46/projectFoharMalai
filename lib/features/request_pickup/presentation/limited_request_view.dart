import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../app_localizations.dart';
import '../../../core/common/widgets/shimmer_loading_widget.dart';
import '../data/pickup_service.dart';
import '../model/PickupRequest.dart';

class LimitedRequestsWidget extends StatefulWidget {
  @override
  _LimitedRequestsWidgetState createState() => _LimitedRequestsWidgetState();
}

class _LimitedRequestsWidgetState extends State<LimitedRequestsWidget> {
  final PickupService _pickupService = PickupService();
  late Future<List<PickupRequest>> _futurePickups;

  @override
  void initState() {
    super.initState();
    _futurePickups = _loadPickupRequests();
  }

  Future<List<PickupRequest>> _loadPickupRequests() async {
    String? userId = await getUserId();
    return await _pickupService.getPickupsByUserIdOrSessionId(userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        FutureBuilder<List<PickupRequest>>(
          future: _futurePickups,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerLoadingEffect();
            } else if (snapshot.hasError) {
              return Center(
                child: buildErrorWidget(localizations, context),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<PickupRequest> limitedRequests =
                  snapshot.data!.take(2).toList();
              return Column(
                children: limitedRequests.map((pickup) {
                  return buildPickupCard(
                      context, pickup, localizations, isDarkMode);
                }).toList(),
              );
            } else {
              return Center(
                child: buildNoRequestWidget(localizations, context),
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildPickupCard(BuildContext context, PickupRequest pickup,
      AppLocalizations localizations, bool isDarkMode) {
    final pickupDate = DateTime.parse(pickup.date);
    final day = pickupDate.day.toString();
    final month = DateFormat('MMM').format(pickupDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? LinearGradient(
                colors: [AppColors.darkModeOnPrimary, AppColors.dark],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : LinearGradient(
                colors: [AppColors.white, AppColors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDarkMode ? null : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.white : AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.roboto(
                          color: isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        month,
                        style: GoogleFonts.roboto(
                          color: isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup.fullName,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    buildIconText(
                      Iconsax.location,
                      '${localizations.translate('address')}: ${pickup.address}',
                      isDarkMode,
                    ),
                    const SizedBox(height: 3),
                    buildIconText(
                      Iconsax.clock,
                      '${localizations.translate('time')}: ${pickup.time}',
                      isDarkMode,
                    ),
                    const SizedBox(height: 3),
                    buildIconText(
                      Iconsax.calendar,
                      '${localizations.translate('date')}: ${pickup.date}',
                      isDarkMode,
                    ),
                    const SizedBox(height: 3),
                    buildIconText(
                      Iconsax.call,
                      '${localizations.translate('phone')}: ${pickup.phoneNumber}',
                      isDarkMode,
                    ),
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
    List<String> parts = text.split(': ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${parts[0]}: ',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextSpan(
                  text: parts.length > 1 ? parts[1] : '',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
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

  Widget buildErrorWidget(
      AppLocalizations localizations, BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Lottie.asset('assets/animations/not_found.json',
              width: 150, height: 150),
          const SizedBox(height: 8),
          Text(
            localizations.translate('error_occurred'),
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.translate('error_message'),
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildNoRequestWidget(
      AppLocalizations localizations, BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Lottie.asset('assets/animations/not_found.json',
              width: 150, height: 150),
          const SizedBox(height: 8),
          Text(
            localizations.translate('no_pickups_found'),
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
