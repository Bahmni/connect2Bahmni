import 'package:connect2bahmni/domain/models/form_definition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meta_provider.dart';

class SelectObsFormWidget extends StatefulWidget {
  const SelectObsFormWidget({Key? key}) : super(key: key);

  @override
  State<SelectObsFormWidget> createState() => _SelectObsFormWidgetState();
}

class _SelectObsFormWidgetState extends State<SelectObsFormWidget> {

  late List<FormResource> forms;
  FormResource? _selectedForm;
  static const lblSelectTemplate = 'Select Observation Template';

  @override
  void initState() {
    super.initState();
    forms = Provider.of<MetaProvider>(context, listen: false).observationForms;
    //_formUuid = forms[0].uuid;

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(lblSelectTemplate),
      content: Column(
        children: forms.map((f) => ListTile(
            title: Text(f.name),
            leading: Radio<FormResource>(
              value: f,
              groupValue: _selectedForm,
              onChanged: (FormResource? value) {
                setState(() {
                  _selectedForm = value;
                });
              },
            )
        )).toList(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context, _selectedForm);
          },
        ),
      ],
    );
  }

}