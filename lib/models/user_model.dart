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
  final Map<String, String> favoriteMeals; 
  final String photoURL;         
  final String backgroundURL;    

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
    required this.photoURL,
    required this.backgroundURL,
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
        'photoURL': photoURL,             
        'backgroundURL': backgroundURL,    
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map['userId'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        privilegedUser: map['privilegedUser'] ?? false,
        dateOfBirth: DateTime.parse(map['dateOfBirth']),
        gender: map['gender'] ?? '',
        createdAt: DateTime.parse(map['createdAt']),
        accountStatus: AccountStatus.values.firstWhere(
          (e) => e.name == map['accountStatus'],
          orElse: () => AccountStatus.active,
        ),
        favoriteMeals: Map<String, String>.from(map['favoriteMeals'] ?? {}),
        photoURL: map['photoURL'] ?? '',             
        backgroundURL: map['backgroundURL'] ?? '',   
      );
      UserModel copyWith({
  String? userId,
  String? name,
  String? email,
  String? password,
  bool? privilegedUser,
  DateTime? dateOfBirth,
  String? gender,
  DateTime? createdAt,
  AccountStatus? accountStatus,
  Map<String, String>? favoriteMeals,
  String? photoURL,
  String? backgroundURL,
}) {
  return UserModel(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    privilegedUser: privilegedUser ?? this.privilegedUser,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    createdAt: createdAt ?? this.createdAt,
    accountStatus: accountStatus ?? this.accountStatus,
    favoriteMeals: favoriteMeals ?? this.favoriteMeals,
    photoURL: photoURL ?? this.photoURL,
    backgroundURL: backgroundURL ?? this.backgroundURL,
  );
}

}
