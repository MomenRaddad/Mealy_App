import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:meal_app/view/screens/user_screens/settings/account_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _profileImage;

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
                        image: UserSession.backgroundURL != null &&
                                UserSession.backgroundURL!.isNotEmpty
                            ? NetworkImage(UserSession.backgroundURL!)
                            : const AssetImage("assets/images/default_background.jpg")
                                as ImageProvider,
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
                                : (UserSession.photoURL != null &&
                                        UserSession.photoURL!.isNotEmpty)
                                    ? NetworkImage(UserSession.photoURL!)
                                    : const AssetImage("assets/images/default_user.png")
                                        as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
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
              const Text("Hey! I'm", style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                UserSession.name ?? 'Guest',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                UserSession.email ?? '',
                style: const TextStyle(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 30),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _tile(
                      icon: Icons.settings,
                      label: "Account Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                        );
                      },
                    ),
                    _tile(icon: Icons.favorite, label: "Favorites", onTap: () {}),
                    _tile(icon: Icons.mail_outline, label: "Contact Us", onTap: () {}),
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
                   
                      UserSession.clear();
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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


  Widget _tile({required IconData icon, required String label, required VoidCallback onTap}) {
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
