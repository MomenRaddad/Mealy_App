import 'package:flutter/material.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:meal_app/utils/navigation_utils.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/user_screens/home/reminders_screen.dart';
import 'package:meal_app/view/screens/user_screens/profile/profile_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            AppNavigator.pushWithNavBar(context, ProfileScreen());            
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: UserSession.photoURL != null
                    ? NetworkImage(UserSession.photoURL!)
                    : const AssetImage('assets/images/default_user.png') as ImageProvider,
              ),
              SizedBox(width: context.wp(10)),
              Text(
                UserSession.name ?? 'Guest',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            AppNavigator.pushWithoutNavBar(context, RemindersScreen());           
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Icon(Icons.notifications_none, size: context.hp(32), color: Theme.of(context).iconTheme.color),
              const Positioned(
                right: 2,
                top: 2,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.red,
                  child: Text('9+', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}
