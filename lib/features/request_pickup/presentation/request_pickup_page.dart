import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../app_localizations.dart';
import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../config/constants/text_strings.dart';
import '../../../core/common/provider/connection.dart';
import '../../../core/common/widgets/custom_snackbar.dart';
import '../../../core/utils/helpers/helper_functions.dart';
import '../../../core/utils/helpers/permission_helper.dart';

class ShiftDetailsView extends ConsumerStatefulWidget {
  const ShiftDetailsView({Key? key}) : super(key: key);

  @override
  _ShiftDetailsViewState createState() => _ShiftDetailsViewState();
}

class _ShiftDetailsViewState extends ConsumerState<ShiftDetailsView> {
  CameraPosition? _initialCameraPosition;
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool isSnackbarShown = false;
  Set<Marker> _markers = {};
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String? apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];

  Future<void> _requestPermissions() async {
    await PermissionHelper.requestLocationPermission(context);
  }

  void _stopTrackingLocation() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> _setInitialCameraPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    _initialCameraPosition = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 15.0,
    );
    _updateAddress(LatLng(currentPosition.latitude, currentPosition.longitude));
    setState(() {});
  }

  Future<void> _updateAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          '${placemark.name}, ${placemark.street}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
      setState(() {
        _addressController.text = address;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _setInitialCameraPosition();
  }

  @override
  void dispose() {
    _stopTrackingLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final connectivityStatus = ref.watch(connectivityStatusProvider);
    final dark = HelperFunctions.isDarkMode(context);

    // Check the internet connectivity
    switch (connectivityStatus) {
      case ConnectivityStatus.isConnected:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: dark ? Colors.black : AppColors.primaryColor,
        ));
        break;
      case ConnectivityStatus.isDisconnected:
        if (!isSnackbarShown) {
          isSnackbarShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: AppColors.error,
            ));
            showSnackBar(
              context: context,
              message: AppTexts.noInternet,
              color: AppColors.error,
            );
          });
        }
        break;
      case ConnectivityStatus.isConnecting:
        break;
      case ConnectivityStatus.notDetermined:
        break;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                if (_initialCameraPosition != null)
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: GoogleMap(
                      trafficEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _initialCameraPosition!,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _markers,
                      onTap: (LatLng latLng) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _markers.clear();
                          _markers.add(Marker(
                            markerId: MarkerId('pinned_location'),
                            position: latLng,
                          ));
                          _updateAddress(latLng);
                        });
                      },
                    ),
                  ),
                Positioned(
                  right: 10.0,
                  bottom: 200,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor:
                        isDarkMode ? AppColors.dark : AppColors.white,
                    foregroundColor:
                        isDarkMode ? AppColors.white : AppColors.dark,
                    elevation: 5.0,
                    onPressed: _setInitialCameraPosition,
                    child: Icon(Icons.my_location),
                    tooltip: 'Locate Me',
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.dark : AppColors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule Pickup',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: AppSizes.spaceBtwnInputFields),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: isDarkMode
                        ? AppColors.darkModeSurface
                        : AppColors.white,
                    surfaceTintColor: AppColors.white,
                    elevation: 4.0,
                    shadowColor: Colors.black.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today),
                                    labelText: 'Pickup Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        dateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                  readOnly: true,
                                ),
                              ),
                              SizedBox(width: AppSizes.spaceBtwnInputFields),
                              Expanded(
                                child: TextFormField(
                                  controller: timeController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.access_time),
                                    labelText: 'Pickup Time',
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        timeController.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spaceBtwnInputFields),
                          GooglePlacesAutoCompleteTextFormField(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('address'),
                              hintText: AppLocalizations.of(context)
                                  .translate('address_hint'),
                              prefixIcon: Icon(MdiIcons.mapMarker),
                            ),
                            textEditingController: _addressController,
                            googleAPIKey: apiKey ?? 'NA',
                            debounceTime: 400,
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (prediction) {
                              print(
                                  "Coordinates: (${prediction.lat},${prediction.lng})");
                            },
                            itmClick: (prediction) {
                              if (prediction.description != null) {
                                _addressController.text =
                                    prediction.description!;
                                _addressController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: prediction.description!.length),
                                );
                              } else {
                                _addressController.clear();
                              }
                            },
                          ),
                          SizedBox(height: AppSizes.spaceBtwnInputFields),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: AppSizes.spaceBtwnInputFields),
                          ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? AppColors.darkModeSurface
                                  : AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.whiteText
                                      : AppColors.whiteText,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
