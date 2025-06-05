import 'package:cloud_firestore/cloud_firestore.dart';

class UserSession {
  static String? uid;
  static String? name;
  static String? email;
  static String? status;
  static String? gender;
  static String? phoneNumber;
  static String? createdAt;
  static String? dob;
  static bool isPrivileged = false;

  static String? photoURL;
  static String? backgroundURL;

  // Static method to refresh user data from the database based on the current UID
  static Future<void> refreshUserData() async {
    if (uid == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null) {
        fromMap(data);
      } else {
        clear();
      }
    } catch (e) {
      print("Error refreshing user data: $e");
      clear();
    }
  }

  static void fromMap(Map<String, dynamic> data) {
    name = data['userName'];
    email = data['userEmail'];
    uid = data['userId'];
    status = data['accountStatus'];
    gender = data['gender'];
    phoneNumber = data['phoneNumber'];
    createdAt = data['createdAt'];
    dob = data['DOB'];
    isPrivileged = data['isPrivileged'] ?? false;
    photoURL = data['photoURL'];
    backgroundURL = data['backgroundURL'];
  }

  static String toStringDetails() {
    return '''
      UserSession Info:
      - UID: $uid
      - Name: $name
      - Email: $email
      - Status: $status
      - Gender: $gender
      - Phone: $phoneNumber
      - Created At: $createdAt
      - DOB: $dob
      - Photo URL: $photoURL
      - Background URL: $backgroundURL
      - Is Privileged: $isPrivileged
    ''';
  }

  static void clear() {
    uid = null;
    name = null;
    email = null;
    status = null;
    gender = null;
    phoneNumber = null;
    createdAt = null;
    dob = null;
    isPrivileged = false;
    photoURL = null;
    backgroundURL = null;
  }
}
