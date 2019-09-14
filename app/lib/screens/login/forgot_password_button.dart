import 'package:flutter/material.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/screens/register/register_screen.dart';
import 'package:tic_tac_toe/screens/reset_password/reset_password_screen.dart';

class ForgotPasswordButton extends StatelessWidget {

  ForgotPasswordButton({Key key} )
      :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Forgot Password',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ResetPasswordScreen();
          }),
        );
      },
    );
  }
}