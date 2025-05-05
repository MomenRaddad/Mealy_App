import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 4,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppConstants.fontMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
/**How to use it ?
 * 
 * 
 return const LoadingWidget();

return const LoadingWidget(message: "Loading meals...");

 */