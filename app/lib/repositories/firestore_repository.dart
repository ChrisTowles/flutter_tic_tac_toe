import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_toe/models_old/User.dart';

class FirestoreRepository {
  final Firestore _firestore;

  FirestoreRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<void> addUserSettingsDB(AuthResult authResult) async {

    User user = new User(
      id: authResult.user.uid,
      email: authResult.user.email,
      name: authResult.user.displayName
    );

    var value = await checkUserExist(user.id);
    if (!value) {
      print("user ${user.name} ${user.email} added");
      //_firestore.document("users/${user.id}").setData(user.toJson());


    } else {
      // print("user ${user.firstName} ${user.email} exists");
    }
  }

  Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
/*
  Future<void> _addSettings(Settings settings) async {
    await _firestore
        .document("settings/${settings.settingsId}")
        .setData(settings.toJson());
  }



  static Future<User> getUserFirestore(String userId) async {
    if (userId != null) {
      return Firestore.instance
          .collection('users')
          .document(userId)
          .get()
          .then((documentSnapshot) => User.fromDocument(documentSnapshot));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  static Future<Settings> getSettingsFirestore(String userid) async {
    if (userid != null) {
      var documentSnapshot = await Firestore.instance
          .collection('settings')
          .document(userid)
          .get();

        return Settings.fromDocument(userid, documentSnapshot);

    } else {
      print('no firestore settings available');
      return null;
    }
  }

  static Future<String> storeUserLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = userToJson(user);
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  static Future<String> storeSettingsLocal(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = settingsToJson(settings);
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = userFromJson(prefs.getString('user'));
      //print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  static Future<Settings> getSettingsLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('settings') != null) {
      Settings settings = settingsFromJson(prefs.getString('settings'));
      //print('SETTINGS: $settings');
      return settings;
    } else {
      return null;
    }
  }
 */
}
