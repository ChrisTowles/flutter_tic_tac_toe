import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/repositories/firestore_repository.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/register/register_form.dart';

import 'bloc/bloc.dart';

class RegisterScreen extends StatelessWidget {

  RegisterScreen({Key key})     :
        super(key: key);

  @override
  Widget build(BuildContext context) {

    var userRepository = Provider.of<UserRepository>(context);
    var firestoreRepository = Provider.of<FirestoreRepository>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(
              userRepository: userRepository,
              firestoreRepository: firestoreRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}