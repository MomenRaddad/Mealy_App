enum AccountStatus { active, inactive, suspended }

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

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.privilegedUser = false,
    required this.dateOfBirth,
    required this.gender,
    required this.createdAt,
    required this.accountStatus,
  });

  Map<String, dynamic> toJson() => {
        'UserID': userId,
        'Name': name,
        'Email': email,
        'Password': password,
        'PrivilegedUser': privilegedUser,
        'DateOfBirth': dateOfBirth.toIso8601String(),
        'Gender': gender,
        'CreatedAt': createdAt.toIso8601String(),
        'AccountStatus': accountStatus.name,

      };
}
