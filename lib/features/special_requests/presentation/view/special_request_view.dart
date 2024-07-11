import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/common/widgets/no_request_found_widget.dart';
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
              backgroundColor: AppColors.whiteText,
              onRefresh: () async {
                ref.refresh(specialRequestsProvider);
              },
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
                        style: GoogleFonts.roboto(color: AppColors.error),
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
                loading: () => const Center(child: CircularProgressIndicator()),
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
    return Card(
      color: isDarkMode ? AppColors.cardDarkMode : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.category,
              style: GoogleFonts.roboto(
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDarkMode ? AppColors.white : AppColors.black,
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
