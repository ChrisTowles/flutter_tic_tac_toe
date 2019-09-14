import 'dart:async';

import 'package:tic_tac_toe/bloc/bloc_provider.dart';
import 'package:tic_tac_toe/models//auth.dart';
import 'package:tic_tac_toe/models/bloc_completer.dart';
import 'package:tic_tac_toe/models/load_status.dart';
import 'package:tic_tac_toe/services/user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tic_tac_toe/models/User.dart';


class AuthBloc extends BlocBase{

  UserService userService;
  BlocCompleter completer;

    final _currentUserSubject = BehaviorSubject<User>.seeded(null);
    final _loadStatusSubject = BehaviorSubject<LoadStatus>.seeded(LoadStatus.loaded);
    final _socialLoginSubject = BehaviorSubject<SocialLoginType>.seeded(null);
    final _signUpSubject = BehaviorSubject<Map>.seeded(null);
    final _loginSubject = BehaviorSubject<Map>.seeded(null);

    Function(SocialLoginType) get loginWithSocial => (socialLoginType) => _socialLoginSubject.sink.add(socialLoginType); 
    Function(String , String, String) get signUp => (username, email, password) => _signUpSubject.sink.add({'username': username, 'email': email, 'password': password});
    Function(String , String) get login => (email, password) => _loginSubject.sink.add({'email': email, 'password': password});


    Stream<LoadStatus> get loadStatus => _loadStatusSubject.stream;

    AuthBloc(this.userService, this.completer){

        _socialLoginSubject.stream.listen(_handleSocialLogin);

        _loginSubject.stream.listen(_handleLogin);

        _signUpSubject.stream.listen(_handleSignUp);

    }

    _handleSocialLogin(SocialLoginType socialLoginType) async {
          _loadStatusSubject.sink.add(LoadStatus.loading);
          /*if(socialLoginType == SocialLoginType.facebook){
            try{
              User user = await userService.authenticateWithFaceBook();
               _loadStatusSubject.sink.add(LoadStatus.loaded);
              completer.completed(user);
            }catch(appError){
               _loadStatusSubject.sink.add(LoadStatus.loaded);
              completer.error(appError);
            }
          }else
            */
            if(socialLoginType == SocialLoginType.google){

              try{

                  User user = await userService.authenticateWithGoogle();
                   _loadStatusSubject.sink.add(LoadStatus.loaded);
                  completer.completed(user);

              }catch(appError){
                 _loadStatusSubject.sink.add(LoadStatus.loaded);
                  completer.error(appError);
              }
          }
        }

    _handleLogin(Map loginCredential) async{
          _loadStatusSubject.sink.add(LoadStatus.loading);
try{
             User user =  await userService.signInWithEmailAndPasword(loginCredential['email'], loginCredential['password']);
              _loadStatusSubject.sink.add(LoadStatus.loaded);
 completer.completed(user);
            }catch(appError){
               _loadStatusSubject.sink.add(LoadStatus.loaded);
                completer.error(appError);
            }
        }

    _handleSignUp(Map signUpCredential) async {
          _loadStatusSubject.sink.add(LoadStatus.loading);

            try{
            User user = await userService.signUpWithEmailAndPassword(signUpCredential['username'], signUpCredential['email'], signUpCredential['password']);
            _loadStatusSubject.sink.add(LoadStatus.loaded);
            completer.completed(user);

            }catch(appError){
               _loadStatusSubject.sink.add(LoadStatus.loaded);
                completer.error(appError);
            }
        }

  @override
  void dispose() {
     _currentUserSubject.close();
    _socialLoginSubject.close();
    _loadStatusSubject.close();
    _signUpSubject.close();
    _loginSubject.close();
  }


}