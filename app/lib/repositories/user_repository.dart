import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/models/User.dart';
import 'package:tic_tac_toe/util/user_util.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();


  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );




   var userCred = await _firebaseAuth.signInWithCredential(credential);

    await _processAuthUser(userCred.user);


    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) async {
    var authResult =  await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _processAuthUser(authResult.user);

  }

  Future<AuthResult> signUp({String email, String password}) async {
    return  await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }


  Future<String> getUserEmail() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }


  Future<User> _processAuthUser(FirebaseUser authUser) async {
    User loggedInUser = User(
        id: authUser.uid,
        email: authUser.email,
        name: authUser.displayName,
        avatarUrl: authUser.photoUrl);

    String fcmToken = await _getTokenFromPreference();
    loggedInUser = loggedInUser.copyWith(fcmToken: fcmToken);
    await _addUserToFireStore(loggedInUser);
    return loggedInUser;
  }


  saveUserFcmTokenToPreference(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  addUserTokenToStore(String userId, String fcmToken) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'fcmToken': fcmToken}, merge: true);
  }

  Future<String> _getTokenFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmToken = prefs.getString('fcm_token');
    return fcmToken;
  }

  Future<Null> _addUserToFireStore(User user) async {
    await Firestore.instance.collection('users').document(user.id).setData({
      'email': user.email,
      'displayName': user.name,
      'fcmToken': user.fcmToken,
      'currentState': UserUtil().getStringFromState(UserState.available)
    });
  }



  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('fcm_token');
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    if (currentUser != null) {
      return User(
          id: currentUser.uid,
          name: currentUser.displayName,
          avatarUrl: currentUser.photoUrl,
          email: currentUser.email,
          fcmToken: token);
    }
    return null;
  }
/*
  checkUserPresence() {
    FirebaseDatabase.instance
        .reference()
        .child('.info/connected')
        .onValue
        .listen((Event event) async {
      if (event.snapshot.value == false) {
        return;
      }
      User currentUser = await getCurrentUser();
      FirebaseDatabase.instance
          .reference()
          .child('/status/' + currentUser.id)
          .onDisconnect()
          .set({
        'state': UserUtil().getStringFromState(UserState.offline)
      }).then((onValue) {
        FirebaseDatabase.instance
            .reference()
            .child('/status/' + currentUser.id)
            .set({'state': UserUtil().getStringFromState(UserState.available)});
      });
    });
  }*/


}