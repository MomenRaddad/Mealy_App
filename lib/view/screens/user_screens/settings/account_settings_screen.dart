import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/viewmodels/profile_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  XFile? _newProfileImage;
  XFile? _newCoverImage;
  final picker = ImagePicker();

  Future<void> _pickImage(bool isCover) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isCover) {
          _newCoverImage = picked;
        } else {
          _newProfileImage = picked;
        }
      });
    }
  }

  Future<String> _uploadImageToStorage(XFile image, String path) async {
    final ref = FirebaseStorage.instance.ref().child('$path/${const Uuid().v4()}');
    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }

  Future<void> _editField(String label, String currentValue, Function(String) onSave) async {
    final controller = TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $label"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editBirthDate(DateTime? currentDate, Function(DateTime) onSave) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onSave(picked);
    }
  }

  Future<void> _saveProfile(ProfileViewModel vm) async {
    final user = vm.user!;
    String newPhotoURL = user.photoURL ?? '';
    String newBackgroundURL = user.backgroundURL ?? '';

    if (_newProfileImage != null) {
      newPhotoURL = await _uploadImageToStorage(_newProfileImage!, 'profile_photos');
    }
    if (_newCoverImage != null) {
      newBackgroundURL = await _uploadImageToStorage(_newCoverImage!, 'cover_photos');
    }

    final updatedUser = user.copyWith(
      photoURL: newPhotoURL,
      backgroundURL: newBackgroundURL,
    );

    await vm.updateUserProfile(updatedUser);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    final user = vm.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover + Profile Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _newCoverImage != null
                              ? FileImage(File(_newCoverImage!.path))
                              : (user.backgroundURL?.isNotEmpty == true
                                  ? NetworkImage(user.backgroundURL!)
                                  : const AssetImage("assets/images/default_cover.jpg")) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(height: 60, color: Colors.grey[100]),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => _pickImage(true),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width / 2 - 55,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _newProfileImage != null
                              ? FileImage(File(_newProfileImage!.path))
                              : (user.photoURL?.isNotEmpty == true
                                  ? NetworkImage(user.photoURL!)
                                  : const AssetImage("assets/images/default_user.png")) as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _pickImage(false),
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

            const SizedBox(height: 40),

            _editableTile(
              title: "Full Name",
              value: user.userName,
              onEdit: () => _editField("Name", user.userName, (val) {
                vm.user = user.copyWith(userName: val);
                vm.notifyListeners();
              }),
            ),
            _editableTile(
              title: "Email",
              value: user.userEmail,
              onEdit: () => _editField("Email", user.userEmail, (val) {
                vm.user = user.copyWith(userEmail: val);
                vm.notifyListeners();
              }),
            ),
            _editableTile(
              title: "Date of Birth",
              value: "${user.DOB.day}/${user.DOB.month}/${user.DOB.year}",
              onEdit: () => _editBirthDate(user.DOB, (val) {
                vm.user = user.copyWith(DOB: val);
                vm.notifyListeners();
              }),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text("Click here to reset or update your password"),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveProfile(vm),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Save Settings"),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _editableTile({
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: AppColors.primary),
        onPressed: onEdit,
      ),
    );
  }
}
