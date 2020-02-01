import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/authentication_service.dart';
import '../../helpers/validators.dart';
import 'bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthService _authService;

  RegistrationBloc({@required AuthService authService})
      : assert(authService != null),
        _authService = authService;

  @override
  RegistrationState get initialState => RegistrationState.empty();

  @override
  Stream<RegistrationState> transformEvents(
    Stream<RegistrationEvent> events,
    Stream<RegistrationState> Function(RegistrationEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegistrationState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      emailValidationStatus: email.length == 0 ? ValidationResult.unknown() : Validators.isValidEmail(email),
    );
  }

  Stream<RegistrationState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      passwordValidationStatus: password.length == 0 ? ValidationResult.unknown() : Validators.isValidPassword(password),
    );
  }

  Stream<RegistrationState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegistrationState.loading();
    try {
      await _authService.signUp(
        email: email,
        password: password,
      );
      yield RegistrationState.success();
    } catch (_) {
      yield RegistrationState.failure();
    }
  }
}
