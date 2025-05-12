import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          EmailInput(
            emailFocusNode: _emailFocusNode,
          )
        ],
      )),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.emailFocusNode});
  final FocusNode emailFocusNode;
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: emailFocusNode,
      validator: (value) {
        _emailRegex.hasMatch(value ?? '');
      },
      decoration: const InputDecoration(
          labelText: 'Email', errorText: 'Invalid Error.'),
    );
  }
}
