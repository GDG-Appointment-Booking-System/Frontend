class Validators {
  Validators._();

  static String? requiredField(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final emptyError = requiredField(value, fieldName: 'Email');
    if (emptyError != null) return emptyError;

    final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    final emptyError = requiredField(value, fieldName: 'Password');
    if (emptyError != null) return emptyError;

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
