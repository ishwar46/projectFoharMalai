import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class WhatWeBuyWidget extends StatelessWidget {
  final List<Item> items = [
    Item('Newspaper', 'assets/images/newspapers.png', 'Re. 1/Kg'),
    Item('Magazines', 'assets/images/books.png', 'Rs. 5/Kg'),
    Item('Cardboard', 'assets/images/cardboard.png', 'Rs. 1.5/Kg'),
    Item('Shampoo', 'assets/images/shampoo.png', 'Rs. 10/Kg'),
    Item('Beer Bottle', 'assets/images/beer.png', 'Re. 1/Pcs'),
    Item('Aluminium', 'assets/images/alum.png', 'Re. 1/Pcs'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.65,
          ),
          itemCount: items.length < 8 ? items.length : 8,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              color: AppColors.whiteText,
              surfaceTintColor: AppColors.whiteText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    items[index].image,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    items[index].title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index].subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
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
