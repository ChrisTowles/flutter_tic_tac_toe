import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/register/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  CreateAccountButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen();
          }),
        );
      },
    );
  }
}
