import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/bloc/note_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void createNote(
    BuildContext context, {
    bool isEditing = false,
    int noteId = 0,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isEditing) {
                      context.read<NoteBloc>().add(UpdateNoteEvent(
                          id: noteId,
                          title: _titleController.text,
                          content: _contentController.text));
                    } else {
                      context.read<NoteBloc>().add(AddNoteEvent(
                          title: _titleController.text,
                          content: _contentController.text));
                    }
                    Navigator.pop(context);
                  } else {
                    return;
                  }

                  _titleController.clear();
                  _contentController.clear();
                },
                child: const Text('Save'),
              ),
            ],
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textFormField(
                        controller: _titleController, labelText: 'Title'),
                    textFormField(
                        controller: _contentController, labelText: 'Content'),
                  ],
                )),
          );
        });
  }

  TextFormField textFormField(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(FetchAllNotesEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          switch (state) {
            case NoteInitial():
              return Center(child: Text(state.message));
            case NoteLoading():
              return const Center(child: CircularProgressIndicator.adaptive());
            case NoteLoaded():
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  String title = state.notes[index].title;
                  String content = state.notes[index].content;
                  return Card(
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(content),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          onPressed: () {
                            createNote(
                              context,
                              isEditing: true,
                              noteId: state.notes[index].id,
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<NoteBloc>().add(
                                DeleteNoteEvent(id: state.notes[index].id));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ]),
                    ),
                  );
                },
              );
            case NoteFailure():
              return Center(child: Text(state.message));
          }
        },
      ),
    );
  }
}
