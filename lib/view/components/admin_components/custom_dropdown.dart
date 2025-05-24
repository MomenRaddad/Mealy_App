import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String selectedValue;
  final List<String> options;
  final void Function(String) onSelected;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCustomPicker(context),
      child: InputDecorator(
        decoration: InputStyles.common(
          label,
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textPrimary,
          ),
        ),
        child: Text(
          selectedValue,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
      ),
    );
  }

  void _showCustomPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ...options.map(
                  (option) => ListTile(
                    title: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              option == selectedValue
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                          fontWeight:
                              option == selectedValue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(option);
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }
}
