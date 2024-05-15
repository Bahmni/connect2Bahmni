import 'package:flutter/material.dart';
import '../domain/models/omrs_order.dart';

class InvestigationDetails extends StatefulWidget {
  final OmrsOrder investigation;
  const InvestigationDetails({super.key, required this.investigation});

  @override
  State<InvestigationDetails> createState() => _InvestigationDetailsState();
}

class _InvestigationDetailsState extends State<InvestigationDetails> {
  late OmrsOrder _investigation;
  final TextEditingController _notesController = TextEditingController();
  static const lblAddInvestigation = "Add Investigation";
  static const lblEnterInvestigationNote = "Enter note for the investigation";

  @override
  void initState() {
    super.initState();
    _investigation = widget.investigation;
    _notesController.text = _investigation.commentToFulfiller ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lblAddInvestigation),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _investigationDisplay(),
          SizedBox(height: 20),
          _commentToFulfiller(),
          SizedBox(height: 20),
          Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50)),
            child: TextButton(
              autofocus: false,
              onPressed: () {
                _investigation.commentToFulfiller = _notesController.text;
                Navigator.pop(context, _investigation);
              },
              child: const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _investigationDisplay() {
    String? display = _investigation.concept?.display ?? '';
    return Text(display, style: TextStyle(fontSize: 20));
  }

  Widget _commentToFulfiller() {
    return TextField(
        controller: _notesController,
        decoration: InputDecoration(
          hintText: lblEnterInvestigationNote,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFDBE2E7),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFDBE2E7),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 40, 24, 0),
        ),
        maxLines: 8,
        style: Theme.of(context).textTheme.bodyLarge!.merge(
            const TextStyle(
              fontFamily: 'Lexend Deca',
              color: Color(0xFF1E2429),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            )),
        textAlign: TextAlign.start,
      );
  }
}
