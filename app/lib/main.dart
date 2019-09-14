import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/home/home_screen.dart';
import 'package:tic_tac_toe/screens/login/login_screen.dart';
import 'package:tic_tac_toe/screens/splash/splash_screen.dart';
import 'package:tic_tac_toe/ui/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication_bloc/bloc.dart';
import 'bloc/simple_bloc_delegate.dart';
/*
class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp Title',
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
*/

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          else if (state is Authenticated) {
            return HomeScreen(name: state.displayName);
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          else {
            return Container();
          }

        },
      ),
    );
  }
}

void main() {

  final UserRepository userRepository = UserRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();


  runApp(
      MultiProvider(
        providers: [
          Provider<UserRepository>.value(value: userRepository),
        ],
        child: BlocProvider(
          builder: (context) => AuthenticationBloc(userRepository: userRepository)
            ..dispatch(AppStarted()),
          child: App(userRepository: userRepository),
        ),
      )

  );
}

/*
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/bloc/game_bloc.dart';
import 'package:tic_tac_toe/bloc/bloc_provider.dart';
import 'package:tic_tac_toe/bloc/user_bloc.dart';
import 'package:tic_tac_toe/menu_page.dart';
import 'package:tic_tac_toe/services/game_service.dart';
import 'package:tic_tac_toe/services/user_service.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    UserService userService = UserService();
    return BlocProvider<UserBloc>(
      bloc: UserBloc(userService: userService),
      child: BlocProvider<GameBloc>(
        bloc: GameBloc(gameService: GameService(), userService: userService),
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Color(0XFF212845),
        accentColor: Color(0XFFF8D320),
        scaffoldBackgroundColor: Color(0XFF212845),
        primarySwatch: Colors.yellow,
        buttonColor: Color(0XFFF8D320),
        hintColor:  Color(0XFFCFC07A),
        textTheme:  TextTheme(
          body1: TextStyle(
            color: Colors.white
          ),
        )
      ),
      home:MenuPage(),
    ),
      ),
    )


      ;
  }
}
*/
