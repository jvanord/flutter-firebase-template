import 'package:meta/meta.dart';
import '../../helpers/validators.dart';

@immutable
class SigninState {
  final ValidationResult emailValidationStatus;
  final ValidationResult passwordValidationStatus;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => emailValidationStatus.isValid && passwordValidationStatus.isValid;

  SigninState({
    @required this.emailValidationStatus,
    @required this.passwordValidationStatus,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory SigninState.empty() {
    return SigninState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SigninState.loading() {
    return SigninState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SigninState.failure() {
    return SigninState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory SigninState.success() {
    return SigninState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  SigninState update({
    ValidationResult emailValidationStatus,
    ValidationResult passwordValidationStatus,
  }) {
    return copyWith(
      emailValidationStatus: emailValidationStatus,
      passwordValidationStatus: passwordValidationStatus,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SigninState copyWith({
    ValidationResult emailValidationStatus,
    ValidationResult passwordValidationStatus,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SigninState(
      emailValidationStatus: emailValidationStatus ?? this.emailValidationStatus,
      passwordValidationStatus: passwordValidationStatus ?? this.passwordValidationStatus,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''SigninState {
      isEmailValid: ${emailValidationStatus.isValid},
      isPasswordValid: ${passwordValidationStatus.isValid},
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
