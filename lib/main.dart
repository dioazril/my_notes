import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/bloc/note_bloc.dart';
import 'package:my_notes/bloc_observer.dart';
import 'package:my_notes/models/note_db.dart';
import 'package:my_notes/pages/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await NoteDatabase.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Notes',
        theme: ThemeData.dark(),
        home: const MyHomePage(),
      ),
    );
  }
}
