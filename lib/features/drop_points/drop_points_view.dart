import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../app_localizations.dart';
import '../../../config/constants/app_colors.dart';
import '../../../core/utils/helpers/helper_functions.dart';
import '../../../core/utils/helpers/permission_helper.dart';

class SelfServiceDropPointsView extends ConsumerStatefulWidget {
  const SelfServiceDropPointsView({Key? key}) : super(key: key);

  @override
  _SelfServiceDropPointsViewState createState() =>
      _SelfServiceDropPointsViewState();
}

class _SelfServiceDropPointsViewState
    extends ConsumerState<SelfServiceDropPointsView> {
  CameraPosition? _initialCameraPosition;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _setInitialCameraPosition();
    _setDropPointMarkers();
  }

  Future<void> _requestPermissions() async {
    await PermissionHelper.requestLocationPermission(context);
  }

  Future<void> _setInitialCameraPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    _initialCameraPosition = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 12.0,
    );
    _userLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
    setState(() {});
  }

  void _setDropPointMarkers() {
    // Drop points around Kathmandu, Lalitpur, and Bhaktapur
    List<LatLng> dropPoints = [
      // Kathmandu
      LatLng(27.7172, 85.3240),
      LatLng(27.7120, 85.3130),
      LatLng(27.7149, 85.3086),
      LatLng(27.7186, 85.3173),
      LatLng(27.7059, 85.3121),
      LatLng(27.7215, 85.3199),
      LatLng(27.7260, 85.3290),
      // Lalitpur
      LatLng(27.6765, 85.3140),
      LatLng(27.6815, 85.3206),
      LatLng(27.6849, 85.3242),
      LatLng(27.6690, 85.3120),
      LatLng(27.6679, 85.3175),
      // Bhaktapur
      LatLng(27.6725, 85.4298),
      LatLng(27.6710, 85.4161),
      LatLng(27.6695, 85.4152),
      LatLng(27.6655, 85.4222),
      LatLng(27.6648, 85.4258),
    ];

    setState(() {
      _markers = dropPoints
          .map(
            (point) => Marker(
              markerId: MarkerId(point.toString()),
              position: point,
              infoWindow: InfoWindow(
                title: 'Foharmalai Drop Point',
                snippet: 'Self-service drop point',
              ),
            ),
          )
          .toSet();

      // Add Head Office marker
      _markers.add(
        Marker(
          markerId: MarkerId('head_office'),
          position: LatLng(27.6905, 85.3700), // Kadaghari coordinates
          infoWindow: InfoWindow(
            title: 'Head Office',
            snippet: 'Foharmalai Head Office',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  LatLng? _getNearestDropLocation() {
    if (_userLocation == null) return null;

    LatLng? nearestLocation;
    double minDistance = double.infinity;

    for (Marker marker in _markers) {
      double distance = Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = marker.position;
      }
    }

    return nearestLocation;
  }

  void _navigateToNearestDropPoint() async {
    LatLng? nearestDropLocation = _getNearestDropLocation();
    if (nearestDropLocation != null && _userLocation != null) {
      final url =
          'https://www.google.com/maps/dir/?api=1&origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${nearestDropLocation.latitude},${nearestDropLocation.longitude}&travelmode=driving';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      showSnackBar(
          message: 'Unable to determine nearest drop point.',
          context: context,
          color: AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('self_service_drop_points')),
        backgroundColor: isDarkMode ? AppColors.dark : AppColors.primaryColor,
      ),
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
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FloatingActionButton(
            onPressed: _navigateToNearestDropPoint,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.directions, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
