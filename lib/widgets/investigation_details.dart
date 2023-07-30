import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:flutter/material.dart';

class InvestigationDetails extends StatefulWidget {
  final OmrsOrder investigation;
  const InvestigationDetails({Key? key, required this.investigation}):super(key:key);

  @override
  State<InvestigationDetails> createState() => _InvestigationDetailsState();
}

class _InvestigationDetailsState extends State<InvestigationDetails> {
  OmrsOrder _omrsOrder = OmrsOrder();
  final TextEditingController _notesController = TextEditingController();
@override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _omrsOrder = widget.investigation;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Investigation"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _investigationDisplay(),
          SizedBox(
            height: 20,
          ),
          _commentToFulfiller(),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.red)
                    )
                )
            ),
            onPressed: () {
              _omrsOrder.commentToFulfiller = _notesController.text;
              Navigator.pop(context, _omrsOrder);
            },
            child:_omrsOrder.commentToFulfiller==null? Text('Add'):Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _investigationDisplay() {
    String? display = _omrsOrder.concept?.display;
    display ??= '??';
    return Text(display,style: TextStyle(
      fontSize: 20
    ),);
  }
  Widget _commentToFulfiller(){
    _notesController.text = _omrsOrder.commentToFulfiller ?? '';
    return Expanded(
      child: TextField(
        controller: _notesController,
        decoration: InputDecoration(
          hintText: "Enter note for the investigation",
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
      ),
    );
  }
}
