import 'package:flutter/material.dart';
import 'package:tic_tac_toe/util/state_widget.dart';
import 'package:tic_tac_toe/ui/theme.dart';
import 'package:tic_tac_toe/ui/screens/home.dart';
import 'package:tic_tac_toe/ui/screens/sign_in.dart';
import 'package:tic_tac_toe/ui/screens/sign_up.dart';
import 'package:tic_tac_toe/ui/screens/forgot_password.dart';

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

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
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
