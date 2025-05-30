import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class StepsField extends StatelessWidget {
  final TextEditingController stepsController;
  final String? Function(String?)? stepsValidator;
  final String? hintText;
  const StepsField({
    super.key,
    required this.stepsController,
    this.stepsValidator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Steps / How To:',
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
        SizedBox(height: context.hp(10)),
        TextFormField(
          keyboardType: TextInputType.multiline,
          controller: stepsController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: stepsValidator,
        ),
      ],
    );
  }
}
