part of 'note_bloc.dart';

@immutable
sealed class NoteState extends Equatable {
  @override
  List<Object> get props => [];
}

final class NoteInitial extends NoteState {
  final String message;

  NoteInitial({required this.message});
  @override
  List<Object> get props => [message];
}

final class NoteLoading extends NoteState {}

final class NoteLoaded extends NoteState {
  final List<Note> notes;

  NoteLoaded({required this.notes});

  @override
  List<Object> get props => [notes];
}

final class NoteFailure extends NoteState {
  final String message;

  NoteFailure({required this.message});

  @override
  List<Object> get props => [message];
}
