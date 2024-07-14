import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/widgets/no_request_found_widget.dart';
import '../../../../core/common/widgets/shimmer_loading_widget.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../data/special_req_serivce.dart';
import '../../domain/special_request.dart';

final specialRequestsProvider =
    FutureProvider<List<SpecialRequest>>((ref) async {
  final specialRequestService = ref.watch(specialRequestServiceProvider);
  return await specialRequestService.fetchSpecialRequests();
});

class SpecialRequestsViewPage extends ConsumerStatefulWidget {
  const SpecialRequestsViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialRequestsViewPageState();
}

class _SpecialRequestsViewPageState
    extends ConsumerState<SpecialRequestsViewPage> {
  String? _selectedCategory;
  final List<String> categories = [
    'Paper Products',
    'Plastics',
    'Glass',
    'Metals',
    'Electronic Waste (E-Waste)',
    'Textiles',
    'Organic Waste (Compostable)',
    'Batteries and Hazardous Waste',
    'Wood',
    'Mixed Waste'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(specialRequestsProvider));
  }

  Future<void> refreshData() async {
    await ref.refresh(specialRequestsProvider.future);
    showSnackBar(message: 'Refresh successful!', context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final specialRequests = ref.watch(specialRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('special_requests'),
          style: GoogleFonts.roboto(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: localizations.translate('select_category'),
                labelStyle: GoogleFonts.roboto(),
                prefixIcon: Icon(Iconsax.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items:
                  categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: GoogleFonts.roboto()),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshData,
              child: specialRequests.when(
                data: (requests) {
                  List<SpecialRequest> filteredRequests = requests;
                  if (_selectedCategory != null) {
                    filteredRequests = requests
                        .where(
                            (request) => request.category == _selectedCategory)
                        .toList();
                  }

                  if (filteredRequests.isEmpty) {
                    return Center(
                      child: Text(
                        localizations.translate('no_special_req'),
                        style: GoogleFonts.roboto(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      return buildRequestCard(
                          context, request, localizations, isDarkMode);
                    },
                  );
                },
                loading: () => const Center(child: ShimmerLoadingEffect()),
                error: (error, _) => NoRequestFoundWidget(
                  onRetry: () {
                    ref.refresh(specialRequestsProvider);
                  },
                  noRequestText: localizations.translate('no_special_req'),
                  lottieAnimationPath: 'assets/animations/not_found.json',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestCard(BuildContext context, SpecialRequest request,
      AppLocalizations localizations, bool isDarkMode) {
    final preferredDate = DateTime.parse(request.preferredDate);
    final day = preferredDate.day.toString();
    final month = DateFormat('MMM').format(preferredDate);

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
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.white : AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
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
            SizedBox(width: 5.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.category,
                      style: GoogleFonts.roboto(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: isDarkMode
                                      ? AppColors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildDetailRow(
                        context,
                        Iconsax.weight,
                        localizations.translate('estimated_waste_or_pieces'),
                        request.estimatedWaste,
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildDetailRow(
                        context,
                        Iconsax.clock,
                        localizations.translate('preferred_time'),
                        request.preferredTime,
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildDetailRow(
                        context,
                        Iconsax.calendar,
                        localizations.translate('preferred_date'),
                        request.preferredDate,
                        isDarkMode),
                    const SizedBox(height: 4),
                    buildDetailRow(
                        context,
                        Iconsax.location,
                        localizations.translate('location'),
                        request.location,
                        isDarkMode),
                    if (request.additionalInstructions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      buildDetailRow(
                          context,
                          Iconsax.note,
                          localizations.translate('additional_instructions'),
                          request.additionalInstructions,
                          isDarkMode),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(BuildContext context, IconData icon, String label,
      String value, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
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
