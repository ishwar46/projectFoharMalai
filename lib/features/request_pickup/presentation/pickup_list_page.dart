import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/common/widgets/shimmer_loading_widget.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app_localizations.dart';
import '../../../core/common/widgets/no_request_found_widget.dart';
import '../data/pickup_service.dart';
import '../model/PickupRequest.dart';

class PickupListPage extends StatefulWidget {
  @override
  _PickupListPageState createState() => _PickupListPageState();
}

class _PickupListPageState extends State<PickupListPage> {
  final PickupService _pickupService = PickupService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<PickupRequest>> _futurePickups;
  List<PickupRequest> _pickupRequests = [];
  List<PickupRequest> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _futurePickups = _loadPickupRequests();
  }

  Future<List<PickupRequest>> _loadPickupRequests() async {
    String? userId = await getUserId();
    List<PickupRequest> pickups =
        await _pickupService.getPickupsByUserIdOrSessionId(userId);
    setState(() {
      _pickupRequests = pickups;
      _filteredRequests = pickups;
    });
    return pickups;
  }

  void _filterRequests(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRequests = _pickupRequests;
      });
    } else {
      setState(() {
        _filteredRequests = _pickupRequests
            .where((pickup) =>
                pickup.fullName.toLowerCase().contains(query.toLowerCase()) ||
                pickup.address.toLowerCase().contains(query.toLowerCase()) ||
                pickup.date.toLowerCase().contains(query.toLowerCase()) ||
                pickup.time.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: localizations.translate('search_by_name'),
                labelStyle: GoogleFonts.roboto(),
                prefixIcon: Icon(Iconsax.search_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterRequests,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PickupRequest>>(
              future: _futurePickups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: ShimmerLoadingEffect());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          '${localizations.translate('error')}: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      var pickup = _filteredRequests[index];
                      return buildPickupCard(
                          context, pickup, localizations, isDarkMode);
                    },
                  );
                } else {
                  return NoRequestFoundWidget(
                    onRetry: () {
                      setState(() {
                        _futurePickups = _loadPickupRequests();
                      });
                    },
                    noRequestText: localizations.translate('no_pickups_found'),
                    lottieAnimationPath: 'assets/animations/not_found.json',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPickupCard(BuildContext context, PickupRequest pickup,
      AppLocalizations localizations, bool isDarkMode) {
    final pickupDate = DateTime.parse(pickup.date);
    final day = pickupDate.day.toString();
    final month = DateFormat('MMM').format(pickupDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
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
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.white : AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
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
                          color: isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        month,
                        style: GoogleFonts.roboto(
                          color: isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0),
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
    List<String> parts = text.split(': ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${parts[0]}: ',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextSpan(
                  text: parts.length > 1 ? parts[1] : '',
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
