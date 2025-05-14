import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3WVOAQ-lryrrplK2pFjnXHmkS_ZSa-VI_rA&s',
              fit: BoxFit.cover,
              width: context.wp(60),
              height: context.wp(60),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                size: context.wp(24),
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(width: context.wp(12)),
        Text(
          "Saif Khalifa",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              iconSize: context.wp(36),
              color: AppColors.textPrimary,
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            const Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                radius: 9,
                backgroundColor: Colors.red,
                child: Text(
                  '9+',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
