import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/controllers/notes_controller.dart';
import 'package:notes_app/main.dart';

void main() {
  testWidgets('app shows notes screen', (WidgetTester tester) async {
    final controller = NotesController();
    await controller.load();

    await tester.pumpWidget(NotesApp(controller: controller));

    expect(find.text('My Notes'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
