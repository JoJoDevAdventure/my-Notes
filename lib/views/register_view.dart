import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/emailVerification/',
                  (route) => false
                  );
                  devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                devtools.log(e.code.toString()) ;
                if (e.code == 'weak-password') {
                  showErrorDialog(context, 'weak password.') ;
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialog(context, 'email already exists.');
                } else if (e.code == 'invalid-email') {
                  showErrorDialog(context, 'invalid e-mail adress.');
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
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