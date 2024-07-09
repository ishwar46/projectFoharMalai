import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
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
  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final specialRequests = ref.watch(specialRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('special_requests')),
      ),
      body: specialRequests.when(
        data: (requests) => ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              color: AppColors.shadepink,
              margin:
                  const EdgeInsets.symmetric(vertical: AppSizes.spaceBtwItems),
              child: ListTile(
                title: Text(request.category),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${localizations.translate('estimated_waste')}: ${request.estimatedWaste}'),
                    Text(
                        '${localizations.translate('preferred_time')}: ${request.preferredTime}'),
                    Text(
                        '${localizations.translate('preferred_date')}: ${request.preferredDate}'),
                    if (request.additionalInstructions.isNotEmpty)
                      Text(
                          '${localizations.translate('additional_instructions')}: ${request.additionalInstructions}'),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            localizations.translate('error_fetching_requests'),
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
