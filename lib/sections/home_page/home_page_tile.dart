
import 'package:flutter/material.dart';
import 'package:studychinesetoday/configs/app_theme.dart';
import 'package:studychinesetoday/configs/constants.dart';

import '../../configs/app_colors.dart';

class HomePageTile extends StatelessWidget {
  const HomePageTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: kBoxShadow,
        ),
        child: Center(child: Text(title, style: Theme.of(context).textTheme.displayMedium,)),
      ),
    );
  }
}