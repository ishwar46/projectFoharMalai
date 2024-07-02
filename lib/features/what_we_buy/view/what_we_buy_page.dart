import 'package:flutter/material.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants/app_colors.dart';

class WhatWeBuyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('What we buy'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
              color: isDarkMode ? AppColors.dark : AppColors.white,
              child: TabBar(
                labelColor: AppColors.whiteText,
                unselectedLabelColor:
                    isDarkMode ? AppColors.light : AppColors.dark,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: AppColors.primaryColor,
                ),
                tabs: [
                  Tab(
                    text: 'Paper',
                    icon: Icon(Icons.description),
                  ),
                  Tab(
                    text: 'Metal & Steel',
                    icon: Icon(Icons.build),
                  ),
                  Tab(
                    text: 'Glass & Plastic',
                    icon: Icon(Icons.local_drink),
                  ),
                  Tab(
                    text: 'E-waste',
                    icon: Icon(Icons.memory),
                  ),
                ],
                labelStyle: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: GoogleFonts.roboto(
                  fontSize: 14,
                ),
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildGridView(context),
            _buildGridView(context),
            _buildGridView(context),
            _buildGridView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 0.75,
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildCard(
            context, 'Newspaper', 'assets/images/newspapers.png', 'Rs. 5/Kg'),
        _buildCard(
            context, 'Magazines', 'assets/images/newspapers.png', 'Re. 10/Kg'),
        _buildCard(context, 'Books & Magazine', 'assets/images/newspapers.png',
            'Re. 20/Kg'),
        _buildCard(
            context, 'Egg Crates', 'assets/images/newspapers.png', 'Rs. 10/Kg'),
        _buildCard(context, 'Invitation cards', 'assets/images/newspapers.png',
            'Rs. 4/Kg'),
        _buildCard(context, 'Notes & Copy', 'assets/images/newspapers.png',
            'Rs. 15/Kg'),
      ],
    );
  }

  Widget _buildCard(
      BuildContext context, String title, String imagePath, String price) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      surfaceTintColor:
          isDarkMode ? AppColors.darkModeOnPrimary : AppColors.white,
      color: isDarkMode ? AppColors.darkModeOnPrimary : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(imagePath,
                  height: 80, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Text(
              price,
              style: GoogleFonts.roboto(
                fontSize: 10,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
