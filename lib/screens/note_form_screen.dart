import 'package:flutter/material.dart';

import '../controllers/notes_controller.dart';
import '../models/note.dart';
import '../widgets/delete_dialog.dart';

/// Used for both adding a new note (note == null)
/// and viewing/editing an existing one.
class NoteFormScreen extends StatefulWidget {
  final NotesController controller;
  final Note? note;

  const NoteFormScreen({super.key, required this.controller, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text;
    final description = _descriptionController.text;

    if (_isEditing) {
      await widget.controller
          .updateNote(widget.note!.id, title: title, description: description);
    } else {
      await widget.controller.addNote(title: title, description: description);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    await widget.controller.deleteNote(widget.note!.id);
    if (mounted) Navigator.of(context).pop();
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'Add Note'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Delete note',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _required(v, 'Title'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                minLines: 5,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _required(v, 'Description'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save Changes' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
