import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/core/constants.dart';
import 'package:meal_app/utils/navigation_utils.dart';
import 'package:meal_app/view/screens/user_screens/favorites/favorites_screen.dart';
import 'package:meal_app/view/screens/user_screens/settings/account_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState(); 
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _profileImage;

  final String userName = "Islam Yasin";
  final String userHandle = "@islamyasin";
  final String profileImageUrl = "https://wallpapersok.com/images/hd/cool-anime-boy-pfp-hotaro-oreki-ejrnayvw61coeizn.jpg";
  final String coverImageUrl = "https://i.pinimg.com/736x/60/cb/46/60cb4600ad2427938722b77faba6426a.jpg";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(coverImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -40,
                    left: MediaQuery.of(context).size.width / 2 - 55,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(File(_profileImage!.path))
                                : NetworkImage(profileImageUrl) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
              const Text(
                "Hey! I'm",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                userHandle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _profileTile(
                      icon: Icons.settings,
                      label: "Account Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                        );
                      },
                    ),
                    _profileTile(
                      icon: Icons.favorite,
                      label: "Favorites",
                      onTap: () {
                        AppNavigator.pushWithNavBar(context, FavoritesScreen());
                      },
                    ),
                    _profileTile(
                      icon: Icons.mail_outline,
                      label: "Contact Us",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
