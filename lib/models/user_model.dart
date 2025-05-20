enum AccountStatus { active, inactive }

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final bool privilegedUser;
  final DateTime dateOfBirth;
  final String gender;
  final DateTime createdAt;
  final AccountStatus accountStatus;
  final Map<String, String> favoriteMeals; // Key: mealId, Value: addedDate (e.g., "19-5-2025")

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.privilegedUser,
    required this.dateOfBirth,
    required this.gender,
    required this.createdAt,
    required this.accountStatus,
    required this.favoriteMeals,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'email': email,
        'password': password,
        'privilegedUser': privilegedUser,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'createdAt': createdAt.toIso8601String(),
        'accountStatus': accountStatus.name,
        'favoriteMeals': favoriteMeals,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map['userId'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        privilegedUser: map['privilegedUser'],
        dateOfBirth: DateTime.parse(map['dateOfBirth']),
        gender: map['gender'],
        createdAt: DateTime.parse(map['createdAt']),
        accountStatus: AccountStatus.values.firstWhere((e) => e.name == map['accountStatus']),
        favoriteMeals: Map<String, String>.from(map['favoriteMeals'] ?? {}),
      );
}
