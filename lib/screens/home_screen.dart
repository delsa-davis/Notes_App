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
        builder: (_) => NoteFormScreen(
          controller: controller,
          note: note,
        ),
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
      backgroundColor: const Color(0xFFF7F7F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F5),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        toolbarHeight: 88,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Notes',
              style: TextStyle(
                color: Color(0xFF202124),
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Capture your thoughts',
              style: TextStyle(
                color: Color(0xFF707070),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),

      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3446A8),
              ),
            );
          }

          final notes = controller.notes;

          if (notes.isEmpty) {
            return const EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoteCard(
                  key: ValueKey(note.id),
                  note: note,
                  onTap: () => _openForm(context, note: note),
                  onDelete: () => _confirmDelete(context, note),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: const Color(0xFF3446A8),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Note',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}