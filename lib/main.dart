import 'package:flutter/material.dart';

import 'controllers/notes_controller.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatefulWidget {
  final NotesController controller;

  NotesApp({super.key, NotesController? controller})
      : controller = controller ?? NotesController();

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.isLoading) {
      widget.controller.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(controller: widget.controller),
    );
  }
}