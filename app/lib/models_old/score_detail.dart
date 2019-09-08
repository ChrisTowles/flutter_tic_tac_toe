import 'package:tic_tac_toe/models_old/User.dart';

class ScoreDetail{


    final User user;
    final int wins;
    final int losses;
    final bool wonLast;

    ScoreDetail({this.user, this.wins, this.losses, this.wonLast});
}