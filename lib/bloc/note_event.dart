part of 'note_bloc.dart';

@immutable
sealed class NoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAllNotesEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final String title;
  final String content;

  AddNoteEvent({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

class UpdateNoteEvent extends NoteEvent {
  final int id;
  final String title;
  final String content;

  UpdateNoteEvent({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [id, title, content];
}

class DeleteNoteEvent extends NoteEvent {
  final int id;

  DeleteNoteEvent({required this.id});

  @override
  List<Object> get props => [id];
}
