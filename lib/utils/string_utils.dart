class StringUtils {

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String trim(String text) {
    return text.trim();
  }


  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

 
  static String shorten(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }


  static String slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') 
        .replaceAll(RegExp(r'\s+'), '-')   
        .replaceAll(RegExp(r'-+'), '-')    
        .trim();
  }
}
