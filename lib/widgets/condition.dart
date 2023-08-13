import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/condition_model.dart';
import '../providers/meta_provider.dart';
import '../providers/user_provider.dart';
import '../domain/models/omrs_concept.dart';

class ConditionWidget extends StatefulWidget {
  final ConditionModel? condition;
  //final OmrsConcept? valueSetCertainty;
  const ConditionWidget({Key? key, this.condition}) : super(key: key);

  @override
  State<ConditionWidget> createState() => _ConditionWidgetState();
}

class _ConditionWidgetState extends State<ConditionWidget> {
  ConditionModel _conditionModel = ConditionModel();
  final TextEditingController _notesController = TextEditingController();
  //var vsCertainty = Provider.of<MetaProvider>(context, listen: false).conditionCertainty;
  OmrsConcept? valueSetCertainty;

  @override
  void initState() {
    super.initState();
    valueSetCertainty = Provider.of<MetaProvider>(context, listen: false).conditionCertainty;
  }


  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserProvider>(context).user;
    var arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is ConditionModel) {
      _conditionModel = arg;
    } else if (widget.condition != null){
      _conditionModel = widget.condition!;
    }

    _conditionModel.recorder = currentUser?.provider;
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
            _rowOrder(),
            _notesSection(context),
            const SizedBox(height: 20),
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)),
              child: TextButton(
                autofocus: false,
                onPressed: () {
                  _conditionModel.note = _notesController.text;
                  Navigator.pop(context, _conditionModel);
                },
                child: const Text('Add',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        )
      )
    );
  }

  Widget _notesSection(BuildContext context) {
    _notesController.text = _conditionModel.note ?? '';
    return Flexible(
      child: Padding(
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
          style: Theme.of(context).textTheme.bodyLarge!.merge(
            const TextStyle(
              fontFamily: 'Lexend Deca',
              color: Color(0xFF1E2429),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            )),
          textAlign: TextAlign.start,
          maxLines: 10,
        )
      )
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.merge(
          const TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF090F13),
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ));
  }

  Widget _rowCertainty() {
    var valueSet = valueSetCertainty?.answers;
    valueSet ??= [];
    if (valueSet.isEmpty) {
      return const SizedBox(height: 1.0);
    }
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
              selectedColor: Colors.lightBlue,
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

  Widget _rowOrder() {
    return Row(
      children:[
        const Expanded(
          child: Text("Order"),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: ConditionOrder.values.map((order) => ChoiceChip(
              padding: const EdgeInsets.all(10),
              label: Text(order.name),
              selected: (_conditionModel.order != null) && (_conditionModel.order == order),
              selectedColor: Colors.lightBlue,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _conditionModel.order = order;
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
              selected: _isSelectedCategory(value),
              selectedColor: Colors.lightBlue,
              onSelected: (selected) {
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

  bool _isSelectedCategory(OmrsConcept value) => (_conditionModel.category != null) && (_conditionModel.category!.uuid == value.uuid);

  Widget _conditionView() {
    String? display = _conditionModel.code?.display;
    String? description = _conditionModel.code?.description;
    String? coding = _conditionModel.code?.coding;

    display ??= '??';
    description ??= '(no details available)';

    return ExpansionTile(
      tilePadding: const EdgeInsets.all(0),
      title: Text(display, style: Theme.of(context).textTheme.titleLarge),
      subtitle: (coding != null) ?  Text(coding, style: Theme.of(context).textTheme.titleMedium) : null,
      //controlAffinity: ListTileControlAffinity.leading,
      children: <Widget>[
        ListTile(title: Text(description, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }

}