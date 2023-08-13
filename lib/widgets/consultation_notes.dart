import 'package:flutter/material.dart';

class ConsultationNotesWidget extends StatefulWidget {
  final String? notes;
  const ConsultationNotesWidget({Key? key, this.notes}) : super(key: key);

  @override
  State<ConsultationNotesWidget> createState() => _ConsultationNotesWidgetState();
}

class _ConsultationNotesWidgetState extends State<ConsultationNotesWidget> {

  final TextEditingController _notesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      _notesController.text = widget.notes!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Consultation Notes'),
      content: TextField(
        controller: _notesController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            border: OutlineInputBorder()
        ),
        minLines: 10,
      ) ,
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context, _notesController.text);
          },
        ),
      ],
    );
  }

}