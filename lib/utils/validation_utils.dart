class ValidationUtils {
 
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    );
    return emailRegex.hasMatch(email.trim());
  }

 
  static bool isValidPassword(String password) {
    return password.trim().length >= 6;
  }

  static bool isValidText(String? text) {
    return text != null && text.trim().isNotEmpty;
  }


  static bool isValidNumber(String text) {
    return double.tryParse(text.trim()) != null;
  }


  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }
}
