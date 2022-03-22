import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}


class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController() ; 
    _password = TextEditingController() ; 
    super.initState() ; 
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
        title: const Text('Register'),
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
                final userCredential =
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password
                      );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  emailVerificationRoute,
                  (route) => false
                  );
                  devtools.log(userCredential.toString());
              } on WeakPasswordAuthException {
                showErrorDialog(
                  context,
                  'weak password.'
                  );
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                  context,
                  'email already exists.'
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'invalid e-mail adress.'
                  );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication error"
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false
              );
            }, 
            child: const Text('Already have an account ? LogIn here!')
          )
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