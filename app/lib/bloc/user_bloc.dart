import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tic_tac_toe/bloc/bloc_provider.dart';
import 'package:tic_tac_toe/models/User.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/util/user_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBloc extends BlocBase {
  final UserRepository _userRepository;

  final _currentUserSubject = BehaviorSubject<User>();
  final _usersSubject = BehaviorSubject<List<User>>();
  final _getUsersSubject = BehaviorSubject<Null>();
  final _changeFcmTokenSubject = BehaviorSubject<String>();
  final _logoutUser = BehaviorSubject<Null>();

  Stream<User> get currentUser => _currentUserSubject.stream;
  Stream<List<User>> get users => _usersSubject.stream;

  Function() get getUsers => () => _getUsersSubject.sink.add(null);

  Function(User) get changeCurrentUser => (user) => _currentUserSubject.sink.add(user);
  Function(String) get changeFcmToken => (token) => _changeFcmTokenSubject.sink.add(token);
  Function() get logoutUser => () => _logoutUser.sink.add(null);

  UserBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository {
    //Get the user on app start up
    _userRepository.getCurrentUser().then((user) {
      if (user != null) {
        _currentUserSubject.sink.add(user);
        //TODO: remove comment from the statement below to enable online presence check.
        // userService.checkUserPresence();
      }
    });

    _getUsersSubject.stream.listen(_handleGetUsers);

    _changeFcmTokenSubject.listen(_handleChangeFcmToken);

    _logoutUser.stream.listen(_handleLogout);
  }

  _handleGetUsers(_) async {
    User currentUser = await _userRepository.getCurrentUser();

    Firestore.instance.collection('users').snapshots().listen((data) {
      List<User> users = data.documents
          .map<User>((userSnapshot) => User(
              id: userSnapshot.documentID,
              name: userSnapshot['displayName'],
              email: null,
              avatarUrl: null,
              fcmToken: userSnapshot['fcmToken'],
              currentState: UserUtil().getStateFromString(userSnapshot['currentState'])))
          .toList();
      if (currentUser != null) {
        users = users.where((user) => user.id != currentUser.id).toList();
      }
      _usersSubject.sink.add(users);
    });
  }

  _handleChangeFcmToken(token) async {
    User currentUser = await _userRepository.getCurrentUser();

    if (currentUser != null) {
      currentUser = currentUser.copyWith(fcmToken: token);
      _currentUserSubject.sink.add(currentUser);
      _userRepository.addUserTokenToStore(currentUser.id, token);
    }

    _userRepository.saveUserFcmTokenToPreference(token);
  }

  _handleLogout(_) {
    _userRepository.signOut();
    _currentUserSubject.sink.add(null);
  }

  @override
  void dispose() {
    _currentUserSubject.close();
    _getUsersSubject.close();
    _getUsersSubject.close();
    _usersSubject.close();
    _logoutUser.close();
  }
}
