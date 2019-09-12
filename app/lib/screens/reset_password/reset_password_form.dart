import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'reset_password_button.dart';

class ResetPasswordForm extends StatefulWidget {
  State<ResetPasswordForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<ResetPasswordForm> {
  final TextEditingController _emailController = TextEditingController();


  ResetPasswordBloc _resetPasswordBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ResetPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sending request...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {

          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Success! Check your Email!'),
                  ],
                ),
              ),
            );
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Password Reset Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),

                  Padding(

                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ResetPasswordButton(
                      onPressed: isRegisterButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _resetPasswordBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _resetPasswordBloc.dispatch(
      Submitted(
        email: _emailController.text,
      ),
    );
  }
}