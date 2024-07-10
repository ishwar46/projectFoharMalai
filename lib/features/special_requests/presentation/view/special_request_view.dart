import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:iconsax/iconsax.dart';
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
              color: isDarkMode ? AppColors.cardDarkMode : Colors.white,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.category,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color:
                                isDarkMode ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Iconsax.weight,
                            color:
                                isDarkMode ? Colors.white70 : Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${localizations.translate('estimated_waste')}: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: request.estimatedWaste,
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                        Icon(Iconsax.clock,
                            color:
                                isDarkMode ? Colors.white70 : Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${localizations.translate('preferred_time')}: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: request.preferredTime,
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                        Icon(Iconsax.calendar,
                            color:
                                isDarkMode ? Colors.white70 : Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${localizations.translate('preferred_date')}: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: request.preferredDate,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (request.additionalInstructions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Iconsax.note,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${localizations.translate('additional_instructions')}: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  TextSpan(
                                    text: request.additionalInstructions,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
