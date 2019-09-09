import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}



getStateFromString(String userStateString){

  UserState state =UserState.values.firstWhere((userState) => userState.toString().split('.')[1] == userStateString);
  return state;
}

getStringFromState(UserState state){

  return state.toString().split('.')[1];
}


enum UserState { available, playing, away, offline }

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;
  final UserState currentState;
  final String fcmToken;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarUrl,
    this.currentState,
    this.fcmToken
  });




  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        avatarUrl: json.containsKey("avatarUrl") ? json["avatarUrl"]: "",
        currentState: json.containsKey("currentState") ? getStateFromString(json["currentState"]) : UserState.available,
        fcmToken: json.containsKey("fcmToken") ? json["fcmToken"]: "",
  );


  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "avatarUrl": avatarUrl,
        "currentState":  getStringFromState(currentState),
        "fcmToken": fcmToken,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
