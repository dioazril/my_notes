import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/models/note_db.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> with NoteDatabase {
  NoteBloc() : super(NoteInitial(message: 'No Notes')) {
    on<NoteEvent>((event, emit) => emit(NoteLoading()));

    on<FetchAllNotesEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 1), () {
        emit(NoteLoading());
      });
      try {
        await fetchAllNotes();
        emit(NoteLoaded(notes: currentNotes));
      } catch (e) {
        emit(NoteFailure(message: e.toString()));
      }
    });

    on<AddNoteEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        emit(NoteLoading());
      });
      try {
        await addNote(event.title, event.content);
        emit(NoteLoaded(notes: currentNotes));
      } catch (e) {
        emit(NoteFailure(message: e.toString()));
      }
    });

    on<UpdateNoteEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        emit(NoteLoading());
      });
      try {
        await updateNote(event.id, event.title, event.content);
        emit(NoteLoaded(notes: currentNotes));
      } catch (e) {
        emit(NoteFailure(message: e.toString()));
      }
    });

    on<DeleteNoteEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 200), () {
        emit(NoteLoading());
      });
      try {
        await deleteNote(event.id);
        emit(NoteLoaded(notes: currentNotes));
      } catch (e) {
        emit(NoteFailure(message: e.toString()));
      }
    });
  }
}
