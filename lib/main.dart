import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verification_view.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart' ;

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
        loginRoute :(context) => const LoginView(),
        registerRoute :(context) => const RegisterView(),
        emailVerificationRoute :(context) => const VerifyEmailView(),
        homeRoute: (context) => const HomePage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            final emailVerified = user?.isEmailVerified ?? false;
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
