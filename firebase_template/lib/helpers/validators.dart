class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  // static final RegExp _passwordRegExp = RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  // );

  static ValidationResult isValidEmail(String email) {
    return _emailRegExp.hasMatch(email) 
      ? ValidationResult.success()
      : ValidationResult.fail('Invalid email address.');
  }

  static ValidationResult isValidPassword(String password) {
    // our password limits won't be overly strict
    if (password.length < 5) return ValidationResult.fail('Password must be at least 5 characters.');
    if (!password.contains(new RegExp(r'\d'))) return ValidationResult.fail('Password must contain at least one number.');
    return ValidationResult.success();
  }
}

class ValidationResult{
  final bool isValid;
  final String message;
  ValidationResult._(this.isValid, this.message);
  static ValidationResult unknown() => ValidationResult._(false, null);
  static ValidationResult success() => ValidationResult._(true, null);
  static ValidationResult fail(String message) => ValidationResult._(false, message);
}
