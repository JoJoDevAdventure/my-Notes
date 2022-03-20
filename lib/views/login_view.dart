import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' ;

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
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email,
                        password: password
                      );
                final user = FirebaseAuth.instance.currentUser ;
                final emailVerified = user?.emailVerified ?? false ;
                if (emailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home/',
                  (route) => false
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  '/emailVerification/',
                   (route) => false
                   );
                }
                
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(context, "User not found");
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context, 'wrong password');
                }
              }
            },
            child: const Text("LogIn"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/register/');
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