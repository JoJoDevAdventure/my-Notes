import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/logout_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verification_view.dart';
import 'dart:developer' as devtools show log;
import 'firebase_options.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/' :(context) => const RegisterView(),
        '/emailVerification/' :(context) => const VerifyEmailView(),
        '/logout/':(context) => const LogoutView(),
        '/home/': (context) => const HomePage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
           if (user == null) {
             devtools.log('no user');
             return const LoginView();
          } else {
            if (!emailVerified) {
             devtools.log('needs to verify');
             return const VerifyEmailView();
            } else {
              devtools.log('all is good');
              return const NotesView();
            }
          }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
