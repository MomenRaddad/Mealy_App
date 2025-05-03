class Helpers {
  static String formatDuration(int minutes) {
    return '$minutes min';
  }

  static String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}
