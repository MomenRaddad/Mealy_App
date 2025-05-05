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
        'https://hips.hearstapps.com/hmg-prod/images/quick-lunch-ideas-660c41f814e0e.jpeg?crop=1.00xw:0.502xh;0,0.277xh&resize=1200:*',
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
