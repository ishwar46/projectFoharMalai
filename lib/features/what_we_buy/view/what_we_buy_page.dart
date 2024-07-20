import 'package:flutter/material.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants/app_colors.dart';

class WhatWeBuyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations.translate('what_we_buy'),
          ),
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
                    text: localizations.translate('paper'),
                    icon: Icon(Icons.description),
                  ),
                  Tab(
                    text: localizations.translate('metal&steel'),
                    icon: Icon(Icons.build),
                  ),
                  Tab(
                    text: localizations.translate('glass&plastic'),
                    icon: Icon(Icons.local_drink),
                  ),
                  Tab(
                    text: localizations.translate('ewaste'),
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
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        List<Item> items = [
          Item('Newspaper', 'assets/images/newspapers.png', 'Rs. 5/Kg'),
          Item('Magazines', 'assets/images/books.png', 'Rs. 10/Kg'),
          Item('Books & Magazine', 'assets/images/books1.png', 'Rs. 20/Kg'),
          Item('Card Board', 'assets/images/cardboard.png', 'Rs. 10/Kg'),
          Item('Invitation cards', 'assets/images/newspapers.png', 'Rs. 4/Kg'),
          Item('Notes & Copy', 'assets/images/newspapers.png', 'Rs. 15/Kg'),
        ];
        return _buildContainer(context, items[index].title, items[index].image,
            items[index].subtitle);
      },
    );
  }

  Widget _buildContainer(
      BuildContext context, String title, String imagePath, String price) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkModeOnPrimary : AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
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

class Item {
  final String title;
  final String image;
  final String subtitle;

  Item(this.title, this.image, this.subtitle);
}
