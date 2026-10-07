import 'package:flutter/material.dart';

import '../controllers/notes_controller.dart';
import '../models/note.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';

class HomeScreen extends StatelessWidget {
  final NotesController controller;

  const HomeScreen({super.key, required this.controller});

  void _openForm(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(controller: controller, note: note),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (confirmed) {
      await controller.deleteNote(note.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = controller.notes;
          if (notes.isEmpty) {
            return const EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                key: ValueKey(note.id),
                note: note,
                onTap: () => _openForm(context, note: note),
                onDelete: () => _confirmDelete(context, note),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add note',
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
