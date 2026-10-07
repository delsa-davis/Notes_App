import 'package:flutter/material.dart';

import 'controllers/notes_controller.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = NotesController();
  await controller.load();
  runApp(NotesApp(controller: controller));
}

class NotesApp extends StatelessWidget {
  final NotesController controller;

  const NotesApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(controller: controller),
    );
  }
}
