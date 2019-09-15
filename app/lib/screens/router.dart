

import 'package:tic_tac_toe/screens/game_board/game_board.dart';
import 'package:tic_tac_toe/screens/game_invite/game_process_page.dart';
import 'package:tic_tac_toe/screens/high_scores/high_score_board.dart';
import 'package:tic_tac_toe/screens/home/home_screen.dart';
import 'package:tic_tac_toe/screens/login/login_screen.dart';
import 'package:tic_tac_toe/screens/menu/menu_page.dart';
import 'package:tic_tac_toe/screens/register/register_screen.dart';
import 'package:tic_tac_toe/screens/reset_password/reset_password_screen.dart';
import 'package:tic_tac_toe/screens/splash/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/users_board/users_board.dart';




class Router {


  static const String splashScreen = '/splash';

  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String resetPasswordScreen = '/reset_password';
  static const String homeScreen = '/home';
  static const String highScoresScreen = '/high_scores';
  static const String gameInviteScreen = '/game_invite';
  static const String gameBoardScreen = '/game_board';
  static const String usersBoardScreen = '/users_board';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: splashScreen),
            builder: (_) => SplashScreen());
      case loginScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: loginScreen),
            builder: (_) => LoginScreen());
      case registerScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: registerScreen),
            builder: (_) => RegisterScreen());
      case resetPasswordScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: resetPasswordScreen),
            builder: (_) => ResetPasswordScreen());
    /*case homeScreen:
        var data = settings.arguments;
        return MaterialPageRoute(
            settings: RouteSettings(name: eventform),
            builder: (_) => EventformPage(dataEdit: data,));*/
      case homeScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: homeScreen),
            builder: (_) => MenuPage());
      case highScoresScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: highScoresScreen),
            builder: (_) => HighScoreBoard());
      case gameInviteScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: gameInviteScreen),
            builder: (_) => GameProcessPage());
      case gameBoardScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: gameBoardScreen),
            builder: (_) => GameBoard());
      case usersBoardScreen:
        return MaterialPageRoute(
            settings: RouteSettings(name: usersBoardScreen),
            builder: (_) => UsersBoard());
      default:
        throw Exception("Unknown Route passed: " + settings.name);

    }
  }
}