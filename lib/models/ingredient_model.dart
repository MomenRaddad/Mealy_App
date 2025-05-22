class Ingredient {
  final String id;
  final String name;
  final String category;

  Ingredient({required this.id, required this.name, required this.category});

  factory Ingredient.fromMap(Map<String, dynamic> data, String documentId) {
    return Ingredient(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
    };
  }
}
