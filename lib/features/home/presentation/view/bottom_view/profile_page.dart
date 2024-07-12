import 'package:flutter/material.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../../../core/common/widgets/user_profile_shimmer.dart';
import '../../../model/user_model.dart';
import '../../../service/user_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> userFuture;
  bool isEditing = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController addressController;
  late TextEditingController mobileNoController;

  @override
  void initState() {
    super.initState();
    userFuture = UserService().getUserProfile();
  }

  void enableEditing(User user) {
    setState(() {
      isEditing = true;
      fullNameController = TextEditingController(text: user.fullName);
      emailController = TextEditingController(text: user.email);
      usernameController = TextEditingController(text: user.username);
      addressController = TextEditingController(text: user.address ?? '');
      mobileNoController = TextEditingController(text: user.mobileNo ?? '');
    });
  }

  void saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        User updatedUser = User(
          id: '',
          fullName: fullNameController.text,
          email: emailController.text,
          username: usernameController.text,
          address: addressController.text,
          mobileNo: mobileNoController.text,
          isAdmin: false,
        );
        bool success = await UserService().updateUserProfile(updatedUser);
        if (success) {
          setState(() {
            isEditing = false;
            userFuture = UserService().getUserProfile();
          });
          showSnackBar(
              message: 'Profile updated successfully', context: context);
        } else {
          showSnackBar(
              message: 'Failed to update profile',
              context: context,
              color: AppColors.error);
        }
      } catch (e) {
        showSnackBar(
            message: ('Error: $e'), context: context, color: AppColors.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Profile",
          style: GoogleFonts.roboto(),
        ),
        elevation: 0,
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                User user = await userFuture;
                enableEditing(user);
              },
            ),
        ],
      ),
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: UserProfileShimmer());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data found"));
          }

          User user = snapshot.data!;

          return SingleChildScrollView(
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
                  child:
                      isEditing ? buildEditForm(user) : buildProfileInfo(user),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(16.0),
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
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Get Your Recycling Hero Certificate',
                          style: GoogleFonts.roboto(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          generateAndSaveCertificate(user.fullName);
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
                  height: 200,
                  'assets/images/bgimagefohar.png',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEditForm(User user) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTextField('Full Name', fullNameController),
          buildTextField('Email', emailController),
          buildTextField('Username', usernameController),
          buildTextField('Address', addressController),
          buildTextField('Mobile No', mobileNoController),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: saveChanges,
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildProfileInfo(User user) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.white,
              radius: 30,
              backgroundImage: user.image != null
                  ? NetworkImage(user.image!)
                  : AssetImage('assets/images/foharmalailogo.png')
                      as ImageProvider,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '@${user.username}',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.0),
        buildInfoSection(
          icon: Icons.person,
          title: 'Personal Information',
          data: {
            'Given Name': user.fullName.split(' ')[0],
            'Middle Name': user.fullName.split(' ').length > 2
                ? user.fullName.split(' ')[1]
                : 'N/A',
            'Last Name': user.fullName.split(' ').last,
            'Preferred Name': user.username,
          },
        ),
        SizedBox(height: 16.0),
        buildInfoSection(
          icon: Icons.contact_phone,
          title: 'Contact Information',
          data: {
            'Address': user.address ?? 'N/A',
            'Mobile Number': user.mobileNo ?? 'N/A',
            'Alternative Number': 'N/A',
            'Email': user.email,
          },
        ),
      ],
    );
  }

  Future<void> generateAndSaveCertificate(String fullName) async {
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
                  fullName,
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

  Widget buildInfoSection({
    required IconData icon,
    required String title,
    required Map<String, String> data,
  }) {
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries
                .map((entry) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.roboto(
                              color: AppColors.whiteText,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            entry.value,
                            style: GoogleFonts.roboto(
                                color: AppColors.whiteText,
                                fontSize: 14,
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
