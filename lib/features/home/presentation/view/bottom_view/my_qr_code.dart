import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodeScreen(),
    );
  }
}

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
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photos.status;
    } else {
      status = await Permission.storage.status;
    }

    if (!status.isGranted) {
      PermissionStatus result;
      if (Platform.isIOS) {
        result = await Permission.photos.request();
      } else {
        result = await Permission.storage.request();
      }

      if (result.isGranted) {
        setState(() {
          _hasPermission = true;
        });
      } else {
        if (result.isPermanentlyDenied) {
          openAppSettings();
        }
        setState(() {
          _hasPermission = false;
        });
      }
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
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
              SizedBox(height: 16),
              Screenshot(
                controller: screenshotController,
                child: QrImageView(
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
                      Directory? directory;
                      if (Platform.isAndroid) {
                        directory = Directory('/storage/emulated/0/Download');
                      } else if (Platform.isIOS) {
                        directory = await getApplicationDocumentsDirectory();
                      }

                      if (directory != null) {
                        String path = '${directory.path}/qr_code.png';
                        await screenshotController.captureAndSave(
                            directory.path,
                            fileName: 'qr_code.png');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('QR Code saved to $path')));
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
                      'Permission to access storage is required to download the QR code.',
                      style: TextStyle(color: Colors.red),
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
