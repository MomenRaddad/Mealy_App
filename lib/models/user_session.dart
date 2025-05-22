class UserSession {
  // This class is used to manage user session data.
  // It stores user information.

  static String? uid;
  static String? name;
  static String? email;
  static String? status;
  static String? gender;
  static String? phoneNumber;
  static String? createdAt;
  static String? dob;
  static bool isPrivileged = false;

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
  }

  static String toStringDetails() {
    return 
    '''
      UserSession Info:
      - UID: $uid
      - Name: $name
      - Email: $email
      - Status: $status
      - Gender: $gender
      - Phone: $phoneNumber
      - Created At: $createdAt
      - DOB: $dob
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
  }
}
