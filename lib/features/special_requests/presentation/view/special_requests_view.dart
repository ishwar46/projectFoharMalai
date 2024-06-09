import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../core/utils/helpers/helper_functions.dart';

class SpecialRequestsPage extends ConsumerStatefulWidget {
  const SpecialRequestsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialRequestsPageState();
}

class _SpecialRequestsPageState extends ConsumerState<SpecialRequestsPage> {
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _gap = SizedBox(
    height: AppSizes.spaceBtwnInputFields,
  );
  final _gapsection = SizedBox(
    height: AppSizes.spaceBtwItems,
  );

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
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: 'category1',
                    child: Text(localizations.translate('category1')),
                  ),
                  DropdownMenuItem(
                    value: 'category2',
                    child: Text(localizations.translate('category2')),
                  ),
                ],
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: localizations.translate('select_category'),
                    prefixIcon: Icon(MdiIcons.shape),
                    hintText: localizations.translate('select_category_hint')),
              ),
              _gap,
              // Estimated Waste or Pieces
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      localizations.translate('estimated_waste_or_pieces'),
                  prefixIcon: Icon(MdiIcons.bottleWine),
                  hintText:
                      localizations.translate('estimated_waste_or_pieces_hint'),
                ),
              ),
              _gap,
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
              _gap,
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
              _gap,
              // Additional Instructions
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('additional_instructions'),
                  hintText:
                      localizations.translate('additional_instructions_hint'),
                  prefixIcon: Icon(MdiIcons.note),
                ),
              ),

              _gapsection,
              // Submit Button
              SizedBox(
                  width: double.infinity,
                  child:
                      ElevatedButton(onPressed: () {}, child: Text("Submit")))
            ],
          ),
        ),
      ),
    );
  }
}
