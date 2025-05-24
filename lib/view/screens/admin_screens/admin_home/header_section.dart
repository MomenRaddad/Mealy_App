import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:meal_app/utils/size_extensions.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl:
                  'https://as1.ftcdn.net/v2/jpg/06/99/46/60/1000_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg',
              fit: BoxFit.cover,
              width: context.wp(80),
              height: context.wp(80),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget:
                  (context, url, error) => Icon(
                    Icons.person,
                    size: context.wp(30),
                    color: Colors.grey,
                  ),
            ),
          ),
        ),
        SizedBox(width: context.wp(20)),
        Text(
          UserSession.name ?? 'Unknown User',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Spacer(),
        IconButton(
          iconSize: context.wp(46),
          color: AppColors.textPrimary,
          icon: Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed('/settingsAdmin');
          },
        ),
      ],
    );
  }
}
