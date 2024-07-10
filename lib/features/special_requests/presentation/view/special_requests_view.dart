import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../data/special_req_serivce.dart';
import '../../domain/special_request.dart';
import 'special_request_view.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return FlutterSecureStorage();
});

class SpecialRequestsPage extends ConsumerStatefulWidget {
  const SpecialRequestsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialRequestsPageState();
}

class _SpecialRequestsPageState extends ConsumerState<SpecialRequestsPage> {
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _estimatedWasteController = TextEditingController();
  final _additionalInstructionsController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitSpecialRequest(WidgetRef ref) async {
    final specialRequestService = ref.read(specialRequestServiceProvider);

    try {
      final specialRequest = SpecialRequest(
        id: '', // This will be set by the server
        user: '', // This will be set by the server
        category: _categoryController.text,
        estimatedWaste: _estimatedWasteController.text,
        preferredTime: _timeController.text,
        preferredDate: _dateController.text,
        additionalInstructions: _additionalInstructionsController.text,
      );

      bool success =
          await specialRequestService.createSpecialRequest(specialRequest);
      if (success) {
        showSnackBar(
          context: context,
          message: 'Special request created successfully',
          color: Colors.green,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'Failed to create special request',
          color: AppColors.error,
        );
      }
    } catch (error) {
      showSnackBar(
        context: context,
        message: "Failed to create special request: $error",
        color: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('special_requests')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.shadepink,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: isDarkMode ? AppColors.warning : AppColors.error,
                    width: 1,
                  ),
                ),
                child: Text(localizations.translate('special_requests_desc')),
              ),
              const SizedBox(
                height: AppSizes.spaceBtwSections,
              ),
              // Waste Category Dropdown
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: localizations.translate('select_category'),
                  prefixIcon: Icon(MdiIcons.shape),
                  hintText: localizations.translate('select_category_hint'),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwnInputFields),
              // Estimated Waste or Pieces
              TextFormField(
                controller: _estimatedWasteController,
                decoration: InputDecoration(
                  labelText:
                      localizations.translate('estimated_waste_or_pieces'),
                  prefixIcon: Icon(MdiIcons.bottleWine),
                  hintText:
                      localizations.translate('estimated_waste_or_pieces_hint'),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwnInputFields),
              // Preferred Time
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: localizations.translate('preferred_time'),
                  prefixIcon: Icon(MdiIcons.clock),
                  hintText: localizations.translate('preferred_time_hint'),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: AppSizes.spaceBtwnInputFields),
              // Preferred Date
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: localizations.translate('preferred_date'),
                  prefixIcon: Icon(MdiIcons.calendar),
                  hintText: localizations.translate('preferred_date_hint'),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: AppSizes.spaceBtwnInputFields),
              // Additional Instructions
              TextFormField(
                controller: _additionalInstructionsController,
                decoration: InputDecoration(
                  labelText: localizations.translate('additional_instructions'),
                  hintText:
                      localizations.translate('additional_instructions_hint'),
                  prefixIcon: Icon(MdiIcons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitSpecialRequest(ref),
                  child: Text(localizations.translate('submit')),
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpecialRequestsViewPage()),
                    );
                  },
                  child: Text('View Requests'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
