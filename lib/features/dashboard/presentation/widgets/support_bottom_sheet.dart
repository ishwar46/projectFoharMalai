import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact & Support',
            style: GoogleFonts.roboto(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          ListTile(
            leading: Icon(MdiIcons.phone),
            title: Text(
              'Phone',
              style: GoogleFonts.roboto(),
            ),
            subtitle: Text(
              '+123 456 7890',
              style: GoogleFonts.roboto(),
            ),
            onTap: () async {
              const phoneUrl = 'tel:+1234567890';
              if (await canLaunch(phoneUrl)) {
                await launch(phoneUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $phoneUrl')),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.email),
            title: Text(
              'Email',
              style: GoogleFonts.roboto(),
            ),
            subtitle: Text(
              'support@example.com',
              style: GoogleFonts.roboto(),
            ),
            onTap: () async {
              const emailUrl = 'mailto:support@example.com';
              if (await canLaunch(emailUrl)) {
                await launch(emailUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $emailUrl')),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.web),
            title: Text(
              'Website',
              style: GoogleFonts.roboto(),
            ),
            subtitle: Text(
              'www.example.com',
              style: GoogleFonts.roboto(),
            ),
            onTap: () async {
              const websiteUrl = 'https://www.example.com';
              if (await canLaunch(websiteUrl)) {
                await launch(websiteUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $websiteUrl')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
