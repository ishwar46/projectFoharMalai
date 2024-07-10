import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../data/special_req_serivce.dart';
import '../../domain/special_request.dart';

final specialRequestsProvider =
    FutureProvider<List<SpecialRequest>>((ref) async {
  final specialRequestService = ref.read(specialRequestServiceProvider);
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
  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final specialRequests = ref.watch(specialRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('special_requests')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: localizations.translate('select_category'),
                prefixIcon: Icon(MdiIcons.filter),
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
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: specialRequests.when(
              data: (requests) {
                List<SpecialRequest> filteredRequests = requests;
                if (_selectedCategory != null) {
                  filteredRequests = requests
                      .where((request) => request.category == _selectedCategory)
                      .toList();
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
              error: (error, _) => Center(
                child: Text(
                  localizations.translate('error_fetching_requests'),
                  style: TextStyle(color: AppColors.error),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            buildDetailRow(
                context,
                Iconsax.weight,
                localizations.translate('estimated_waste'),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
