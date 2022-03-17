import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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

      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Enter your e-mail here",
                        hintStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 16)),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password here",
                      hintStyle:
                          TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                        );
                      } on FirebaseAuthException catch (e) {
                        print(e.code) ;
                        if (e == 'weak-password') {
                          print('weak password !') ;
                        } else if (e == 'email-already-in-use') {
                          print('e-mail already in use ! ') ;
                        } else if (e == 'invalid-email') {
                          print("invalid email !") ;
                        }
                       }
                    },
                    child: const Text("Register"),
                  ),
                ],
              );
            default:
              return const Text("Loading");
          }
        },
      ),
    );
  }
}