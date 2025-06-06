// import 'package:flutter/material.dart';
// import 'package:meal_app/models/meal_model.dart';
// import 'package:meal_app/utils/size_extensions.dart';
// import 'package:meal_app/view/components/admin_components/meal_card.dart';
// import 'package:meal_app/view/screens/admin_screens/add_meal/add_meal.dart';
// import 'package:meal_app/view/screens/admin_screens/meals_management/edit_meal.dart';
// import 'package:meal_app/viewmodels/AdminMealsViewModel.dart';
// import 'package:provider/provider.dart';
// import 'package:meal_app/view/components/search_bar.dart';
// import 'package:meal_app/view/components/filter_chip_list.dart';

// class MealsManagementScreen extends StatefulWidget {
//   const MealsManagementScreen({super.key});

//   @override
//   State<MealsManagementScreen> createState() => _MealsManagementScreenState();
// }

// class _MealsManagementScreenState extends State<MealsManagementScreen> {
//   final List<String> filters = ["All", "Easy", "Simple", "Difficult", "Medium"];
//   String selectedFilter = "All";
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AdminMealsViewModel>(context);

//     if (viewModel.meals.isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         viewModel.listenToMeals();
//       });
//       return const Center(
//         child: Text('No meals available', style: TextStyle(fontSize: 18)),
//       );
//     }

//     if (viewModel.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final filteredMeals =
//         viewModel.meals.where((meal) {
//           final matchesSearch = meal.name.toLowerCase().contains(
//             searchQuery.toLowerCase(),
//           );
//           final matchesFilter =
//               selectedFilter == "all" || meal.difficulty.name == selectedFilter;
//           return matchesSearch && matchesFilter;
//         }).toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Meals Management")),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: context.hp(7),
//             horizontal: context.wp(7),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SearchBarWidget(
//                 hintText: "Search meals...",
//                 onChanged: (query) => setState(() => searchQuery = query),
//               ),
//               const SizedBox(height: 16),

//               FilterChipList(
//                 filters: filters,
//                 initiallySelected: selectedFilter,
//                 onSelected:
//                     (filter) =>
//                         setState(() => selectedFilter = filter.toLowerCase()),
//               ),
//               const SizedBox(height: 16),

//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: context.hp(8),
//                   horizontal: context.wp(15),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: filteredMeals.length,
//                   itemBuilder: (context, index) {
//                     final meal = filteredMeals[index];
//                     return MealCard(
//                       title: meal.name,
//                       imageUrl: meal.photoUrl,
//                       type: meal.dietaryType.name,
//                       timeAndCal:
//                           '${meal.duration.label} • ${meal.calories} kcal',
//                       likes: meal.likes,
//                       chefs: meal.chefs,
//                       rating: meal.rating,
//                       onEdit: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => EditMealScreen(meal: meal),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
