import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../../core/utils/validators/validators.dart';
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
  final _estimatedWasteController = TextEditingController();
  final _additionalInstructionsController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  LatLng? selectedCoordinates;
  String? apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];

  final List<String> _categories = [
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
    _clearControllers();
  }

  void _clearControllers() {
    _timeController.clear();
    _dateController.clear();
    _estimatedWasteController.clear();
    _additionalInstructionsController.clear();
    _locationController.clear();
    _selectedCategory = null;
  }

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final specialRequestService = ref.read(specialRequestServiceProvider);

    try {
      final specialRequest = SpecialRequest(
        id: '',
        user: '',
        category: _selectedCategory ?? 'Not specified',
        estimatedWaste: _estimatedWasteController.text,
        preferredTime: _timeController.text,
        preferredDate: _dateController.text,
        additionalInstructions: _additionalInstructionsController.text,
        location: _locationController.text,
      );

      bool success =
          await specialRequestService.createSpecialRequest(specialRequest);
      if (success) {
        showSnackBar(
          context: context,
          message: 'Special request created successfully',
          color: Colors.green,
        );
        _clearControllers();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpecialRequestsViewPage()),
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
        message: "Failed to create special request. All fields are required.",
        color: AppColors.error,
      );
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    _estimatedWasteController.dispose();
    _additionalInstructionsController.dispose();
    _locationController.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.dark : AppColors.shadepink,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: isDarkMode ? AppColors.warning : AppColors.error,
                      width: 1,
                    ),
                  ),
                  child: Text(localizations.translate('special_requests_desc')),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: localizations.translate('select_category'),
                    prefixIcon: Icon(Iconsax.category),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Estimated Waste or Pieces
                TextFormField(
                  controller: _estimatedWasteController,
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate('estimated_waste_or_pieces'),
                    prefixIcon: Icon(Iconsax.barcode),
                    hintText: localizations
                        .translate('estimated_waste_or_pieces_hint'),
                  ),
                  validator: (value) =>
                      AppValidator.validateField(value, 'Estimated Waste'),
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Preferred Time
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: localizations.translate('preferred_time'),
                    prefixIcon: Icon(Iconsax.clock),
                    hintText: localizations.translate('preferred_time_hint'),
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  validator: (value) =>
                      AppValidator.validateField(value, 'Preferred Time'),
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Preferred Date
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: localizations.translate('preferred_date'),
                    prefixIcon: Icon(Iconsax.calendar),
                    hintText: localizations.translate('preferred_date_hint'),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) =>
                      AppValidator.validateField(value, 'Preferred Date'),
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Location
                GooglePlacesAutoCompleteTextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.translate('address'),
                    prefixIcon: Icon(Iconsax.location),
                    hintText: localizations.translate('address_hint'),
                  ),
                  textEditingController: _locationController,
                  googleAPIKey: apiKey ?? 'NA',
                  debounceTime: 400,
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (prediction) {
                    setState(() {
                      selectedCoordinates = LatLng(
                        double.parse(prediction.lat.toString()),
                        double.parse(prediction.lng.toString()),
                      );
                    });
                  },
                  itmClick: (prediction) {
                    if (prediction.description != null) {
                      _locationController.text = prediction.description!;
                      _locationController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    } else {
                      _locationController.clear();
                    }
                  },
                  validator: AppValidator.validateAddress,
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Additional Instructions
                TextFormField(
                  controller: _additionalInstructionsController,
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate('additional_instructions'),
                    hintText:
                        localizations.translate('additional_instructions_hint'),
                    prefixIcon: Icon(Iconsax.note),
                  ),
                  maxLines: 2,
                  validator: (value) => AppValidator.validateField(
                      value, 'Additional Instructions'),
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.secondaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpecialRequestsViewPage()),
                      );
                    },
                    child: Text(
                      localizations.translate('view_req'),
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
