import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';
import '../../../../../core/colors.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.navbarBackground,
          automaticallyImplyLeading: true,
          title: const Text(
            'User Account',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        SizedBox(height: context.hp(16)),
        const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
