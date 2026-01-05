class AppValidators {

  // 1. Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Standard Regex for email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // 2. Password Validation (Firebase requires min 6 chars)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // 3. Name Validation (User Name or Product Name)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    if (value.length < 3) {
      return 'Must be at least 3 characters';
    }
    return null;
  }

  // 4. Phone Number Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length < 11) {
      return 'Enter a valid 11-digit phone number';
    }
    return null;
  }

  // 5. ✅ NEW: Price Validation (For Admin - Add Product)
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter price';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  // 6. ✅ NEW: Address Validation (For Checkout)
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter delivery address';
    }
    if (value.length < 10) {
      return 'Please enter complete address details';
    }
    return null;
  }
}