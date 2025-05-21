import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/core/colors.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  XFile? _profileImage;
  XFile? _coverImage;

  String _name = "Islam Yasin";
  String _email = "0islamyasin@gmail.com";
  DateTime? _birthDate;

  final picker = ImagePicker();
  final String userId = '1'; // static userId for now

  Future<void> _pickImage(bool isCover) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isCover) {
          _coverImage = picked;
        } else {
          _profileImage = picked;
        }
      });
    }
  }

  Future<String> _uploadImage(XFile file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    String? profileURL;
    String? backgroundURL;

    if (_profileImage != null) {
      profileURL = await _uploadImage(_profileImage!, 'users/$userId/profile.jpg');
    }
    if (_coverImage != null) {
      backgroundURL = await _uploadImage(_coverImage!, 'users/$userId/background.jpg');
    }

    final updates = {
      'user_name': _name,
      'email': _email,
      if (profileURL != null) 'photoURL': profileURL,
      if (backgroundURL != null) 'backgroundURL': backgroundURL,
    };

    await FirebaseFirestore.instance.collection('profile').doc(userId).update(updates);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully.")),
      );
    }
  }

  Future<void> _editField(String title, String initialValue, Function(String) onSave) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter $title"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Future<void> _editBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          image: _coverImage != null
                              ? FileImage(File(_coverImage!.path))
                              : const NetworkImage("https://images.unsplash.com/photo-1517816743773-6e0fd518b4a6") as ImageProvider,
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
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : const NetworkImage("https://via.placeholder.com/150") as ImageProvider,
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
              value: _name,
              onEdit: () => _editField("Name", _name, (val) => setState(() => _name = val)),
            ),
            _editableTile(
              title: "Email",
              value: _email,
              onEdit: () => _editField("Email", _email, (val) => setState(() => _email = val)),
            ),
            _editableTile(
              title: "Date of Birth",
              value: _birthDate != null
                  ? "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}"
                  : "Not set",
              onEdit: _editBirthDate,
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
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
