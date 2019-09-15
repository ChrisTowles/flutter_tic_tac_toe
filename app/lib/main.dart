import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/repositories/firestore_repository.dart';
import 'package:tic_tac_toe/screens/menu/menu_page.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/home/home_screen.dart';
import 'package:tic_tac_toe/screens/login/login_screen.dart';
import 'package:tic_tac_toe/screens/splash/splash_screen.dart';
import 'package:tic_tac_toe/services/game_service.dart';
import 'package:tic_tac_toe/ui/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication_bloc/bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/game_bloc.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'bloc/user_bloc.dart';

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },*/
      theme: buildTheme(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          } else if (state is Authenticated) {
            // return HomeScreen(name: state.displayName);
            return MenuPage();
          }
          if (state is Unauthenticated) {
            return LoginScreen();
          } else {
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
          Provider<FirestoreRepository>.value(value: FirestoreRepository()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(
                  builder: (context) => AuthenticationBloc(userRepository: userRepository)..dispatch(AppStarted())),
            ],
            child: TTTBlocProvider<UserBloc>(
                bloc: UserBloc(userRepository: userRepository),
                child: TTTBlocProvider<GameBloc>(
                  bloc: GameBloc(gameService: GameService(), userRepository: userRepository),
                  child: App(),
                )))),
  );
}
