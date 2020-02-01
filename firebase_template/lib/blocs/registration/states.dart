import 'package:meta/meta.dart';
import '../../helpers/validators.dart';

@immutable
class RegistrationState {
  final ValidationResult emailValidationStatus;
  final ValidationResult passwordValidationStatus;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => emailValidationStatus.isValid && passwordValidationStatus.isValid;

  RegistrationState({
    @required this.emailValidationStatus,
    @required this.passwordValidationStatus,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegistrationState.empty() {
    return RegistrationState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegistrationState.loading() {
    return RegistrationState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegistrationState.failure() {
    return RegistrationState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegistrationState.success() {
    return RegistrationState(
      emailValidationStatus: ValidationResult.success(),
      passwordValidationStatus: ValidationResult.success(),
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegistrationState update({
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

  RegistrationState copyWith({
    ValidationResult emailValidationStatus,
    ValidationResult passwordValidationStatus,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegistrationState(
      emailValidationStatus: emailValidationStatus ?? this.emailValidationStatus,
      passwordValidationStatus: passwordValidationStatus ?? this.passwordValidationStatus,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegistrationState {
      isEmailValid: ${emailValidationStatus.isValid},
      isPasswordValid: ${passwordValidationStatus.isValid},
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
