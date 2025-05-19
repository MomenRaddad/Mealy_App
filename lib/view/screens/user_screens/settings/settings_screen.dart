import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/provider/theme_provider.dart';
import 'package:meal_app/view/screens/user_screens/history/history_summary_screen.dart';

class SettingsPreferencesScreen extends StatefulWidget {
  const SettingsPreferencesScreen({super.key});

  @override
  State<SettingsPreferencesScreen> createState() => _SettingsPreferencesScreenState();
}

class _SettingsPreferencesScreenState extends State<SettingsPreferencesScreen> {
  bool remindersEnabled = true;
  String selectedLanguage = "English";
  final List<String> customCategories = ["Work", "Health", "Study"];

  void _addCategory() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => customCategories.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cache cleared")),
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );
  }

  void _openHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistorySummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings & Preferences"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Arabic", child: Text("العربية")),
              ],
              onChanged: (val) => setState(() => selectedLanguage = val!),
            ),
          ),

          SwitchListTile(
            title: const Text("Reminders"),
            secondary: const Icon(Icons.notifications_active),
            value: remindersEnabled,
            onChanged: (val) => setState(() => remindersEnabled = val),
          ),

          const Divider(height: 30),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Meal Visit History"),
            onTap: _openHistoryScreen,
          ),

          const Divider(height: 30),

          const Text("Custom Task Categories", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...customCategories.map(
            (cat) => ListTile(
              leading: const Icon(Icons.label_outline),
              title: Text(cat),
            ),
          ),
          TextButton.icon(
            onPressed: _addCategory,
            icon: const Icon(Icons.add),
            label: const Text("Add New Category"),
          ),

          const Divider(height: 30),

          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text("Clear Cache"),
            onTap: _clearCache,
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
