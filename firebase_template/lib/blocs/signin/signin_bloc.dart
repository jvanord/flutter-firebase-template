import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/authentication_service.dart';
import '../../helpers/validators.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<SigninEvent, SigninState> {
  AuthService _authService;

  LoginBloc({
    @required AuthService injectedAuthService,
  })  : assert(injectedAuthService != null),
        _authService = injectedAuthService;

  @override
  SigninState get initialState => SigninState.empty();

  @override
  Stream<SigninState> transformEvents(
    Stream<SigninEvent> events,
    Stream<SigninState> Function(SigninEvent event) next,
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
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<SigninState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      emailValidationStatus: email.length == 0 ? ValidationResult.unknown() : Validators.isValidEmail(email),
    );
  }

  Stream<SigninState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      passwordValidationStatus: password.length == 0 ? ValidationResult.unknown() : Validators.isValidPassword(password),
    );
  }

  Stream<SigninState> _mapLoginWithGooglePressedToState() async* {
    yield SigninState.loading();
    try {
      await _authService.signInWithGoogle();
      yield SigninState.success();
    } catch (_) {
      yield SigninState.failure();
    }
  }

  Stream<SigninState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SigninState.loading();
    try {
      await _authService.signIn(email, password);
      yield SigninState.success();
    } catch (_) {
      yield SigninState.failure();
    }
  }
}
