import 'package:my_notes/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

mixin NoteDatabase {
  static late Isar isar;

  /// initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // List of all notes
  final List<Note> currentNotes = [];

  // Create
  Future<void> addNote(String titleFromUser, String contentFromUser) async {
    final newNote = Note()
      ..title = titleFromUser
      ..content = contentFromUser;

    // save to db
    await isar.writeTxn(() async {
      isar.notes.put(newNote);
    });

    // re-read from db
    await fetchAllNotes();
  }

  // Read
  Future<void> fetchAllNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
  }

  // Update
  Future<void> updateNote(int id, String title, String content) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.title = title;
      existingNote.content = content;
      await isar.writeTxn(() async {
        await isar.notes.put(existingNote);
      });
      // re-read from db
      await fetchAllNotes();
    }
  }

  // Delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      isar.notes.delete(id);
    });
    // re-read from db
    await fetchAllNotes();
  }
}
