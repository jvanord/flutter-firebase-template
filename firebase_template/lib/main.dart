import 'package:firebase_template/views/home.dart';
import 'package:firebase_template/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_template/blocs/authentication/bloc.dart';
import 'package:firebase_template/blocs/dev_bloc_delegate.dart';
import 'package:firebase_template/services/authentication_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // init before run
  BlocSupervisor.delegate = DevBlocDelegate(); // use in-dev delegate to observe
  final AuthService authService = AuthService();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) => AuthenticationBloc(authService)..add(AppStarted()),
    child: TemplateApp(injectedAuthService: authService),
  ));
}

class TemplateApp extends StatelessWidget {
  final AuthService _authService;
  TemplateApp({Key key, @required AuthService injectedAuthService})
      : assert(injectedAuthService != null),
        _authService = injectedAuthService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Template',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticated) {
              return HomePage(user: state.user);
            }
            return Container(
              child: Center(
                child: Text('State failure on load.'),
              ),
            );
          },
        ));
  }
}
