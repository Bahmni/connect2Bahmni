import 'package:connect2bahmni/domain/models/omrs_concept.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/models/condition_model.dart';
import '../providers/user_provider.dart';

class ConditionWidget extends StatefulWidget {
  final OmrsConcept? concept;
  const ConditionWidget({Key? key, this.concept}) : super(key: key);

  @override
  _ConditionWidgetState createState() => _ConditionWidgetState();
}

  enum SingingCharacter { lafayette, jefferson }

class _ConditionWidgetState extends State<ConditionWidget> {
  ConditionModel _conditionModel = ConditionModel();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _currentUser = Provider.of<UserProvider>(context).user;
    var arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is ConditionModel) {
      _conditionModel = arg;
    }
    _conditionModel.code = widget.concept;
    _conditionModel.recorder = _currentUser?.provider;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Condition'),),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height:10),
            _conditionView(),
            _rowCategory(),
            _rowCertainty(),
            _notesSection(context),
            const SizedBox(height: 20),
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
                _conditionModel.note = _notesController.text;
                Navigator.pop(context, _conditionModel);
              },
              child: const Text('Add Condition'),
            ),
          ],
        )
      )
    );
  }

  Padding _notesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
      child: TextFormField(
        controller: _notesController,
        obscureText: false,
        decoration: InputDecoration(
          labelStyle: _labelStyle(context),
          hintText: 'comments ...',
          hintStyle: _labelStyle(context),
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
        style: Theme.of(context).textTheme.bodyText1!.merge(
          const TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF1E2429),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          )),
        textAlign: TextAlign.start,
        maxLines: 4,
      )
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.merge(
          const TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF090F13),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ));
  }

  Row _rowCertainty() {
    var valueSet = _conditionModel.valueSetVerificationStatus;
    return Row(
      children:[
        const Expanded(
           child: Text("Certainty"),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: valueSet.map((value) => ChoiceChip(
              padding: const EdgeInsets.all(10),
              label: Text(value.display ?? ''),
              selected: (_conditionModel.verificationStatus != null) && (_conditionModel.verificationStatus!.uuid == value.uuid),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _conditionModel.verificationStatus = value;
                  });
                }
              },
            )).toList(),
          ),
        ),
      ],
    );
  }

  Row _rowCategory() {
    var valueSet = _conditionModel.valueSetCategory;
    return Row(
      children:[
        const Expanded(
          child: Text("Category",),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: valueSet.map((value) => ChoiceChip(
              padding: const EdgeInsets.all(10),
              label: Text(value.display ?? ''),
              selected: (_conditionModel.category != null) && (_conditionModel.category!.uuid == value.uuid),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _conditionModel.category = value;
                  });
                }
              },
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _conditionView() {
    String? display = _conditionModel.code?.display;
    String? description = _conditionModel.code?.description;
    String? coding = _conditionModel.code?.coding;

    display ??= '??';
    description ??= '(no details available)';

    return ExpansionTile(
      tilePadding: const EdgeInsets.all(0),
      title: Text(display, style: Theme.of(context).textTheme.headline6),
      subtitle: (coding != null) ?  Text(coding, style: Theme.of(context).textTheme.subtitle1) : null,
      //controlAffinity: ListTileControlAffinity.leading,
      children: <Widget>[
        ListTile(title: Text(description, style: Theme.of(context).textTheme.caption)),
      ],
    );
  }

}