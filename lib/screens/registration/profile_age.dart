import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/date_time.dart';

class AgeDisplayWidget extends StatefulWidget {
  final DateTime? initialValue;
  final bool? editMode;
  final Function()? onCancel;
  final Function(DateTime value)? onSet;

  const AgeDisplayWidget({super.key, this.editMode, this.initialValue, this.onSet, this.onCancel});

  @override
  State<AgeDisplayWidget> createState() => _AgeDisplayWidgetState();
}

const String lblYears = 'Years';
const String lblMonths = 'Months';
const String lblDays = 'Days';


class _AgeDisplayWidgetState extends State<AgeDisplayWidget> {
  DateTime? dateOfBirth;
  int? years;
  int? months;
  int? days;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }


  @override
  void didUpdateWidget(AgeDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _init();
    }
  }

  void _init() {
    dateOfBirth = widget.initialValue;
    isEditing = widget.editMode ?? false;
    _calculateAge(dateOfBirth);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //debugAge(),
        const SizedBox(height: 16),
        isEditing ? _buildEditForm() : _buildEditButton(),
        const SizedBox(height: 16),
        displayDateOfBirth(),
      ],
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Text('Edit Age'),
    );
  }

  Widget _buildEditForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextFormField(
            maxLength: 3,
            readOnly: !isEditing,
            initialValue: years?.toString(),
            decoration: InputDecoration(labelText: lblYears, counterText: ''),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => years = int.tryParse(value) ?? years,
          ),
        ),
        SizedBox(width: 5,),
        Flexible(
          child: TextFormField(
            maxLength: 2,
            readOnly: !isEditing,
            initialValue: months?.toString(),
            decoration: InputDecoration(labelText: lblMonths, counterText: ''),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => months = int.tryParse(value) ?? months,
          ),
        ),
        SizedBox(width: 5,),
        Flexible(
            child: TextFormField(
              maxLength: 2,
              readOnly: !isEditing,
              initialValue: days?.toString(),
              decoration: InputDecoration(labelText: lblDays, counterText: ''),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => days = int.tryParse(value) ?? days,
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.update),
              highlightColor: Colors.pink,
              onPressed: () {
                if (widget.onSet != null) {
                  _updateDateOfBirth();
                  widget.onSet?.call(dateOfBirth!);
                } else {
                  setState(() {
                    isEditing = false;
                    _updateDateOfBirth();
                    _calculateAge(dateOfBirth);
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              highlightColor: Colors.pink,
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel?.call();
                } else {
                  setState(() {
                    isEditing = false;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _updateDateOfBirth() {
    final currentDate = DateTime.now();
    if (years != null && months != null && days != null) {
      dateOfBirth = currentDate.subtract(
          Duration(days: (years! * 365) + (months! * 30) + days!));
    }
  }

  void _calculateAge(DateTime? date) {
    if (date == null) {
      return;
    }
    var personAge = calculateAge(date);
    years = personAge.year;
    months = personAge.month;
    days = personAge.days;
  }

  Row debugAge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Age:'),
        const SizedBox(width: 8),
        //Text(_displayYears()),
        Text('$years years'),
        const SizedBox(width: 8),
        Text('$months months'),
        const SizedBox(width: 8),
        Text('$days days'),
      ],
    );
  }

  Widget displayDateOfBirth() {
    final currentDate = DateTime.now();
    if (years != null && months != null && days != null) {
      var date = currentDate.subtract(
          Duration(days: (years! * 365) + (months! * 30) + days!));
      return Text('DOB: ${DateFormat("dd-MM-yyyy").format(date)}', textAlign: TextAlign.left,);
    }
    return Text('DOB: ');
  }
}