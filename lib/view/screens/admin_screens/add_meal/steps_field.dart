import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';

class StepsField extends StatelessWidget {
  final TextEditingController stepsController;
  const StepsField({super.key, required this.stepsController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.hp(10)),
        TextField(
          keyboardType: TextInputType.multiline,
          controller: stepsController,
          maxLines: 6,
          decoration: InputStyles.common("Steps / How To:"),
        ),
      ],
    );
  }
}
