import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String type;
  final String timeAndCal;
  final int likes;
  final int chefs;
  final double rating;
  final VoidCallback? onEdit;
  const MealCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.timeAndCal,
    required this.likes,
    required this.chefs,
    required this.rating,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child:
                    imageUrl != ""
                        ? Image.network(
                          imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          "https://syria.adra.cloud/wp-content/uploads/2021/10/empty.jpg",
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Padding(
          //   // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   padding: const EdgeInsets.only(left: 12, top: 8, bottom: 2),
          //   child: Text(
          //     title,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //       color: AppColors.textPrimary,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
          //   child: Text(
          //     timeAndCal,
          //     style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          //   ),
          // ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 2),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text(
                      timeAndCal,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 8,
                  bottom: 8,
                  right: 12,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: onEdit,
                ),
              ),
            ],
          ),

          // // SizedBox(height: 12),
          Container(width: double.infinity, height: 1, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconStat(
                  context,
                  Icons.favorite_outlined,
                  likes.toString(),
                ),
                _buildIconStat(context, Icons.person, chefs.toString()),
                _buildIconStat(
                  context,
                  Icons.star_purple500_outlined,
                  rating.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconStat(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: AppColors.textPrimary),
        SizedBox(width: context.wp(4)),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
