import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../../app_localizations.dart';
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
              message: AppLocalizations.of(context)
                  .translate('profile_updated_successfully'),
              context: context);
        } else {
          showSnackBar(
              message: AppLocalizations.of(context)
                  .translate('failed_to_update_profile'),
              context: context,
              color: AppColors.error);
        }
      } catch (e) {
        showSnackBar(
            message: '${AppLocalizations.of(context).translate('error')}: $e',
            context: context,
            color: AppColors.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).translate('my_profile'),
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
            return Center(
                child: Text(
                    "${AppLocalizations.of(context).translate('error')}: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(
                child: Text(
                    AppLocalizations.of(context).translate('no_data_found')));
          }

          User user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkModeOnPrimary
                        : AppColors.primaryColor,
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
                    color:
                        isDark ? AppColors.darkModeOnPrimary : AppColors.white,
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
                          AppLocalizations.of(context)
                              .translate('get_recycling_hero_certificate'),
                          style: GoogleFonts.roboto(
                            color: isDark ? AppColors.white : AppColors.dark,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          generateAndSaveCertificate(user.fullName);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('click_here'),
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
          buildTextField(AppLocalizations.of(context).translate('full_name'),
              fullNameController),
          buildTextField(
              AppLocalizations.of(context).translate('email'), emailController),
          buildTextField(AppLocalizations.of(context).translate('username'),
              usernameController),
          buildTextField(AppLocalizations.of(context).translate('address'),
              addressController),
          buildTextField(AppLocalizations.of(context).translate('mobile_no'),
              mobileNoController),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: TextStyle(
                        color:
                            Colors.white), // Set the button text color to white
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: saveChanges,
                  child: Text(
                    AppLocalizations.of(context).translate('save'),
                    style: TextStyle(
                        color:
                            Colors.white), // Set the button text color to white
                  ),
                ),
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          floatingLabelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${AppLocalizations.of(context).translate('please_enter')} $label';
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
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.image ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/foharmalailogo.png'),
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
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
          title: AppLocalizations.of(context).translate('personal_information'),
          data: {
            AppLocalizations.of(context).translate('given_name'):
                user.fullName.split(' ')[0],
            AppLocalizations.of(context).translate('middle_name'):
                user.fullName.split(' ').length > 2
                    ? user.fullName.split(' ')[1]
                    : 'N/A',
            AppLocalizations.of(context).translate('last_name'):
                user.fullName.split(' ').last,
            AppLocalizations.of(context).translate('preferred_name'):
                user.username,
          },
        ),
        SizedBox(height: 16.0),
        buildInfoSection(
          icon: Icons.contact_phone,
          title: AppLocalizations.of(context).translate('contact_information'),
          data: {
            AppLocalizations.of(context).translate('address'):
                user.address ?? 'N/A',
            AppLocalizations.of(context).translate('mobile_number'):
                user.mobileNo ?? 'N/A',
            AppLocalizations.of(context).translate('alternative_number'): 'N/A',
            AppLocalizations.of(context).translate('email'): user.email,
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
