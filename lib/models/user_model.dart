enum AccountStatus { active, inactive }

class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime DOB;
  final String gender;
  final bool isPrivileged;
  final String accountStatus;
  final DateTime createdAt;
  final String phoneNumber;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.DOB,
    required this.gender,
    required this.isPrivileged,
    required this.accountStatus,
    required this.createdAt,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'DOB': DOB.toIso8601String(),
        'gender': gender,
        'isPrivileged': isPrivileged,
        'accountStatus': accountStatus,
        'createdAt': createdAt.toIso8601String(),
        'phoneNumber': phoneNumber,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? 'Unknown',
    userEmail: json['userEmail'] ?? '',
    accountStatus: json['accountStatus'] ?? 'inactive',
    isPrivileged: json['isPrivileged'] ?? false,
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    phoneNumber: json['phoneNumber'] ?? '',
    gender: json['gender'] ?? 'Unspecified',
    DOB: DateTime.tryParse(json['DOB'] ?? '') ?? DateTime(2000),
  );

}
