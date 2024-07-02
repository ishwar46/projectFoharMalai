import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

import '../../../../../core/utils/size_config.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Profile",
          style: GoogleFonts.roboto(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(sizeConfig.safeBlockHorizontal * 4),
              margin: EdgeInsets.all(sizeConfig.safeBlockHorizontal * 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(
                    sizeConfig.safeBlockHorizontal * 1.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: sizeConfig.safeBlockHorizontal * 2.5,
                    offset: Offset(0, sizeConfig.safeBlockVertical * 1.25),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: sizeConfig.safeBlockHorizontal * 7.5,
                        backgroundImage:
                            AssetImage('assets/images/foharmalailogo.png'),
                      ),
                      SizedBox(width: sizeConfig.safeBlockHorizontal * 2.5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Roj Maharjan',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: sizeConfig.safeBlockHorizontal * 3.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '@panduhomoh',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: sizeConfig.safeBlockVertical * 2),
                  buildInfoSection(
                    icon: Icons.person,
                    title: 'Personal Information',
                    data: {
                      'Given Name': 'Roj',
                      'Middle Name': 'N/A',
                      'Last Name': 'Maharjan',
                      'Preferred Name': 'Pandu',
                    },
                    sizeConfig: sizeConfig,
                  ),
                  SizedBox(height: sizeConfig.safeBlockVertical * 2),
                  buildInfoSection(
                    icon: Icons.contact_phone,
                    title: 'Contact Information',
                    data: {
                      'Address': 'Kirtipur, Kathmandu',
                      'Mobile Number': '9812123131',
                      'Alternative Number': 'N/A',
                      'Email': 'N/A',
                    },
                    sizeConfig: sizeConfig,
                  ),
                ],
              ),
            ),
            SizedBox(height: sizeConfig.safeBlockVertical),
            Container(
              padding: EdgeInsets.all(sizeConfig.safeBlockHorizontal * 2),
              margin: EdgeInsets.symmetric(
                  horizontal: sizeConfig.safeBlockHorizontal * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    sizeConfig.safeBlockHorizontal * 1.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: sizeConfig.safeBlockHorizontal * 1.25,
                    offset: Offset(0, sizeConfig.safeBlockVertical * 1.25),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Colors.green),
                  SizedBox(width: sizeConfig.safeBlockHorizontal * 2.5),
                  Expanded(
                    child: Text(
                      'Get Your Recycling Hero Certificate',
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      generateAndSaveCertificate();
                    },
                    child: Text(
                      'Click Here',
                      style: GoogleFonts.roboto(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              height: sizeConfig.safeBlockVertical * 25,
              'assets/images/bgimagefohar.png',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateAndSaveCertificate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Recycling Hero Certificate',
                  style: pw.TextStyle(fontSize: 24),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'This is to certify that',
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Roj Maharjan',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'has been recognized as a Recycling Hero for his outstanding efforts in waste management and recycling.',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Date: ${DateTime.now().toLocal()}',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/recycling_hero_certificate.pdf");
    await file.writeAsBytes(await pdf.save());

    print("Certificate saved at ${file.path}");
  }

  Widget buildInfoSection(
      {required IconData icon,
      required String title,
      required Map<String, String> data,
      required SizeConfig sizeConfig}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: sizeConfig.safeBlockHorizontal * 2.5),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: sizeConfig.safeBlockHorizontal * 3.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: sizeConfig.safeBlockVertical * 2),
        Container(
          padding: EdgeInsets.all(sizeConfig.safeBlockHorizontal * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries
                .map((entry) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: sizeConfig.safeBlockVertical * 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.roboto(
                              color: AppColors.whiteText,
                              fontSize: sizeConfig.safeBlockHorizontal * 3,
                            ),
                          ),
                          Text(
                            entry.value,
                            style: GoogleFonts.roboto(
                                color: AppColors.whiteText,
                                fontSize: sizeConfig.safeBlockHorizontal * 3,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
