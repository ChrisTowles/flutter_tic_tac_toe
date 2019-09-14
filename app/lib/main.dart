import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/screens/menu/menu_page.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/home/home_screen.dart';
import 'package:tic_tac_toe/screens/login/login_screen.dart';
import 'package:tic_tac_toe/screens/splash/splash_screen.dart';
import 'package:tic_tac_toe/services/game_service.dart';
import 'package:tic_tac_toe/services/user_service.dart';
import 'package:tic_tac_toe/ui/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication_bloc/bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/game_bloc.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'bloc/user_bloc.dart';

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

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
          }
          else if (state is Authenticated) {
            //return HomeScreen(name: state.displayName);
            return MenuPage();
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

  UserService userService = UserService();

  runApp(
    MultiProvider(
        providers: [
          Provider<UserRepository>.value(value: userRepository),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(
                  builder: (context) =>
                  AuthenticationBloc(userRepository: userRepository)
                    ..dispatch(AppStarted())
              ),
            ],
            child:
            TTTBlocProvider<UserBloc>(
                bloc: UserBloc(userService: userService),
                child: TTTBlocProvider<GameBloc>(
                  bloc: GameBloc(
                      gameService: GameService(), userService: userService),
                  child: App(userRepository: userRepository),
                )
            )
        )
    ),
  );


}
