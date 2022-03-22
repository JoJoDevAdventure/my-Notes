import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key? key }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
      
    late final TextEditingController _email;
    late final TextEditingController _password;

    @override
    void initState() {
      _email = TextEditingController();
      _password = TextEditingController();
      super.initState(); 
    }

    @override
    void dispose() {
      _email.dispose();
      _password.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogIn'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Enter your e-mail here",
                hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 16)),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
              hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password
                  );
                final user = AuthService.firebase().currentUser ;
                final emailVerified = user?.isEmailVerified ?? false ;
                if (emailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute,
                  (route) => false
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  emailVerificationRoute,
                   (route) => false
                   );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "User not found"
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'wrong password');
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication error"
                );
              }
            },
            child: const Text("LogIn"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(registerRoute);
            },
            child: const Text('Not registred yet? Register here!'),
          ),
        ],
      ),
    );
  }
}

//Alert View
Future<void> showErrorDialog(
  BuildContext context,
  String text
) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: const Text('An error occurred'),
      content: Text(text),
      actions: [
        TextButton
        (onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'))
      ],
    );
  },
  );
}