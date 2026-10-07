import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// Holds the list of notes, notifies listeners on change and persists
/// the data locally with SharedPreferences.
class NotesController extends ChangeNotifier {
  static const _storageKey = 'notes_v1';

  final List<Note> _notes = [];
  bool _isLoading = true;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _notes
        ..clear()
        ..addAll(decoded.map((e) => Note.fromJson(e as Map<String, dynamic>)));
      _sort();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    _notes.add(Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    ));
    _sort();
    notifyListeners();
    await _save();
  }

  Future<void> updateNote(
    String id, {
    required String title,
    required String description,
  }) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      title: title.trim(),
      description: description.trim(),
    );
    notifyListeners();
    await _save();
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _save();
  }

  // Newest first.
  void _sort() => _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_notes.map((n) => n.toJson()).toList()),
    );
  }
}
