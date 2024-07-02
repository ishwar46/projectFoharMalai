import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';

import '../../../../../config/constants/app_colors.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    requestPhotosPermission();
  }

  Future<void> requestPhotosPermission() async {
    PermissionStatus permissionStatus = await Permission.photos.status;

    if (permissionStatus.isDenied) {
      PermissionStatus result = await Permission.photos.request();
      if (result.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    setState(() {
      _hasPermission = permissionStatus.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My QR Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSizes.xl),
              Screenshot(
                controller: screenshotController,
                child: QrImageView(
                  foregroundColor: AppColors.primaryColor,
                  data: 'Ishwar Chaudhary',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Ishwar Chaudhary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (_hasPermission)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final image = await screenshotController.capture();
                      if (image != null) {
                        final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(image),
                          quality: 60,
                          name: "qr_code",
                        );
                        if (result["isSuccess"]) {
                          showSnackBar(
                            message: 'QR Code saved to gallery',
                            context: context,
                          );
                        } else {
                          showSnackBar(
                            message: 'Failed to save QR Code',
                            context: context,
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.download),
                    label: Text('Download QR Code'),
                  ),
                )
              else
                Column(
                  children: [
                    Text(
                      'Permission to access photos is required to download the QR code.',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          openAppSettings();
                        },
                        child: Text('Open Settings'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
