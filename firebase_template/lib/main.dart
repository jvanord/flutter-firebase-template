import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication/bloc.dart';
import 'blocs/dev_bloc_delegate.dart';
import 'services/authentication_service.dart';
import 'views/splash_screen.dart';
import 'views/home.dart';
import 'views/signin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // init before run
  BlocSupervisor.delegate = DevBlocDelegate(); // use in-dev delegate to observe
  final AuthService authService = AuthService();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) => AuthenticationBloc(authService), // ..add(AppStarted()), - don't start until we show the splash screen
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
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Unauthenticated) {
              return LoginScreen(authService: _authService);
            }
            if (state is Authenticated) {
              return HomePage(user: state.user);
            }
            // show Splash and start app (after a pause for effect)
            Future.delayed(const Duration(seconds: 2)).whenComplete(() =>
              BlocProvider.of<AuthenticationBloc>(context).add(AppStarted())
            );
            return SplashScreen(); // default
          },
        ));
  }
}
