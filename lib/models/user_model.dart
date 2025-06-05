enum AccountStatus { active, inactive }

class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime DOB;
  final String gender;
  final bool isPrivileged;
  final AccountStatus accountStatus;
  final DateTime createdAt;
  final String phoneNumber;
  final String? photoURL;       
  final String? backgroundURL;  

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
    this.photoURL,
    this.backgroundURL,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'DOB': DOB.toIso8601String(),
        'gender': gender,
        'isPrivileged': isPrivileged,
        'accountStatus': accountStatus.name,
        'createdAt': createdAt.toIso8601String(),
        'phoneNumber': phoneNumber,
        if (photoURL != null) 'photoURL': photoURL,
        if (backgroundURL != null) 'backgroundURL': backgroundURL,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId']?.toString() ?? '',
        userName: json['userName'] ?? 'Unknown',
        userEmail: json['userEmail'] ?? '',
        accountStatus: AccountStatus.values.firstWhere(
          (e) => e.name == json['accountStatus'],
          orElse: () => AccountStatus.inactive,
        ),
        isPrivileged: json['isPrivileged'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        phoneNumber: json['phoneNumber'] ?? '',
        gender: json['gender'] ?? 'Unspecified',
        DOB: DateTime.tryParse(json['DOB'] ?? '') ?? DateTime(2000),
        photoURL: json['photoURL'],
        backgroundURL: json['backgroundURL'],
      );

  UserModel copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    DateTime? DOB,
    String? gender,
    bool? isPrivileged,
    AccountStatus? accountStatus,
    DateTime? createdAt,
    String? phoneNumber,
    String? photoURL,
    String? backgroundURL,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      DOB: DOB ?? this.DOB,
      gender: gender ?? this.gender,
      isPrivileged: isPrivileged ?? this.isPrivileged,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      backgroundURL: backgroundURL ?? this.backgroundURL,
    );
  }
}
