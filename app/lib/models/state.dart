import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_toe/models/user.dart';
import 'package:tic_tac_toe/models/settings.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
