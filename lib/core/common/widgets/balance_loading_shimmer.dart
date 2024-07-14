import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class BalanceLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(height: 4.0),
                Container(
                  width: 150,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
