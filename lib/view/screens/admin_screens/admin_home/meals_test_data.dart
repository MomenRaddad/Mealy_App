class Meal {
  final String title;
  final String imageUrl;
  final String type;
  final String timeAndCal;
  final int likes;
  final int chefs;
  final double rating;

  Meal({
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.timeAndCal,
    required this.likes,
    required this.chefs,
    required this.rating,
  });
}

final List<Meal> meals = [
  Meal(
    title: 'Fruit-topped pancake',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/mealyapp-86001.firebasestorage.app/o/meal_images%2F1747758977882.jpg?alt=media&token=745ab260-ce69-4f00-bd5a-d9369640e902',
    type: 'Breakfast',
    timeAndCal: '10 min • 300 kcal',
    likes: 75,
    chefs: 75,
    rating: 4.3,
  ),
  Meal(
    title: 'Quick Lunch',
    imageUrl:
        'https://publish.purewow.net/wp-content/uploads/sites/2/2023/07/easy-fast-lunch-recipes_universal.jpg?fit=2050%2C1100',
    type: 'Lunch',
    timeAndCal: '15 min • 700 kcal',
    likes: 100,
    chefs: 80,
    rating: 4.5,
  ),
];
