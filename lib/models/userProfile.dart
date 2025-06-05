class UserProfile {
  final String userName;
  final String email;
  final String photoURL;
  final String backgroundURL;

  UserProfile({
    required this.userName,
    required this.email,
    required this.photoURL,
    required this.backgroundURL,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['user_name'] ?? '',
      email: json['email'] ?? '',
      photoURL: json['photoURL'] ?? '',
      backgroundURL: json['backgroundURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'photoURL': photoURL,
      'backgroundURL': backgroundURL,
    };
  }
}
