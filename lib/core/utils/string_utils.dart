/// String utilities and validation helpers for MediRx Patient
class StringUtils {
  StringUtils._();

  /// Capitalize first character of string
  static String capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  /// Capitalize each word in a string (e.g. "dr. john doe" -> "Dr. John Doe")
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isNotEmpty ? capitalizeFirst(word) : '')
        .join(' ');
  }

  /// Check if valid email address
  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email.trim());
  }

  /// Check if valid phone number (e.g. Bangladesh / international format)
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return false;
    final cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
    final regex = RegExp(r'^(\+?[0-9]{10,14})$');
    return regex.hasMatch(cleaned);
  }

  /// Mask phone number for privacy (e.g. "+88017****123")
  static String maskPhone(String phone) {
    if (phone.length < 8) return phone;
    final start = phone.substring(0, 5);
    final end = phone.substring(phone.length - 3);
    final masked = '*' * (phone.length - 8);
    return '$start$masked$end';
  }
}
