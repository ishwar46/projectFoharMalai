import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/foharmalailogo.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Roj Maharjan',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14,
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
                  SizedBox(height: 20),
                  buildInfoSection(
                    icon: Icons.person,
                    title: 'Personal Information',
                    data: {
                      'Given Name': 'Roj',
                      'Middle Name': 'N/A',
                      'Last Name': 'Maharjan',
                      'Preferred Name': 'Pandu',
                    },
                  ),
                  SizedBox(height: 10),
                  buildInfoSection(
                    icon: Icons.contact_phone,
                    title: 'Contact Information',
                    data: {
                      'Address': 'Kirtipur, Kathmandu',
                      'Mobile Number': '9812123131',
                      'Alternative Number': 'N/A',
                      'Email': 'N/A',
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Get Your Recycling Hero Certificate',
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Click Here',
                      style: GoogleFonts.roboto(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              height: 200,
              'assets/images/bgimagefohar.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSection(
      {required IconData icon,
      required String title,
      required Map<String, String> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.roboto(
                              color: AppColors.whiteText,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            entry.value,
                            style: GoogleFonts.roboto(
                                color: AppColors.whiteText,
                                fontSize: 12,
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
