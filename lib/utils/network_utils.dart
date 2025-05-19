import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meal_app/core/colors.dart';

class NetworkUtils {
  static Future<bool> checkInternetAndShowDialog(BuildContext context) async {
    final result = await Connectivity().checkConnectivity();
    final isConnected = result != ConnectivityResult.none;

    if (!isConnected) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(Icons.wifi_off, color: AppColors.error),
                  SizedBox(width: 10),
                  Text(
                    'No Internet',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Please check your internet connection and try again.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await checkInternetAndShowDialog(context);
                  },
                  icon: Icon(Icons.refresh, color: AppColors.primary),
                  label: Text(
                    'Retry',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                  label: Text(
                    'Close',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
      );
    }

    return isConnected;
  }
}
