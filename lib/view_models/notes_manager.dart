// File: lib/view_models/features/notes_manager.dart

import '../models/note.dart';
import '../database/database_helper.dart';

class NotesManager {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> addNote(String name, String content) async {
    Map<String, dynamic> noteMap = {
      'name': name,
      'content': content,
    };
    int id = await _dbHelper.insertNote(noteMap);
    Note newNote = Note(
      id: id,
      name: name,
      content: content,
    );
    _notes.insert(0, newNote);
  }

  Future<void> deleteNote(int id) async {
    int result = await _dbHelper.deleteNote(id);
    if (result > 0) {
      _notes.removeWhere((note) => note.id == id);
    }
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null) {
      return;
    }

    int result = await _dbHelper.updateNote(note.toMap());
    if (result > 0) {
      int index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
      }
    }
  }

  Future<void> loadNotes() async {
    List<Map<String, dynamic>> noteMaps = await _dbHelper.getNotes();
    _notes = noteMaps.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    List<Map<String, dynamic>> noteMaps = await _dbHelper.searchNotes(query);
    return noteMaps.map((map) => Note.fromMap(map)).toList();
  }

  bool get isNotesEmpty => _notes.isEmpty;
}
