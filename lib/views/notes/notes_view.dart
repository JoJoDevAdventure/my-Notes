import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email! ;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          },
          icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialogOut(context);
                  if (shouldLogOut) {
                    await FirebaseAuth.instance.signOut() ;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Sign out'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreatUser(email: userEmail),
        builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allnotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Waiting for all notes...');
                      default:
                      return const CircularProgressIndicator();
                    }
                  }
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        )
    );
  }
}

Future<bool> showLogOutDialogOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    }
  ).then((value) => value ?? false);
}