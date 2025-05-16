import 'package:flutter/material.dart';
import 'package:meal_app/core/routes.dart';
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: const NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3WVOAQ-lryrrplK2pFjnXHmkS_ZSa-VI_rA&s',
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Saif Khalifa", // replace with dynamic username later
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RemindersScreen()),
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Icon(Icons.notifications_none, size: 32, color: Theme.of(context).iconTheme.color),
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
