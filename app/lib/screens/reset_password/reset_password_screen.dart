import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/reset_password/reset_password_form.dart';
import 'bloc/bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userRepository = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Center(
        child: BlocProvider<ResetPasswordBloc>(
          builder: (context) => ResetPasswordBloc(userRepository: userRepository),
          child: ResetPasswordForm(),
        ),
      ),
    );
  }
}
