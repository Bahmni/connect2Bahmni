
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../domain/models/omrs_visit_type.dart';
import '../providers/meta_provider.dart';


class VisitTypesFab extends StatelessWidget {
  final Function(OmrsVisitType visitType)? onSelect;
  final IconData? icon;
  final String? label;

  const VisitTypesFab({super.key, this.label, this.icon, this.onSelect});

  @override
  Widget build(BuildContext context) {
    var visitTypes = Provider.of<MetaProvider>(context, listen: false).visitTypes;
    return SpeedDial(
        icon: icon,
        label: label != null ? Text(label!) : null,
        buttonSize: Size(50, 48),
        backgroundColor: Colors.pink,
        children: [
          ..._startVisitOptions(context, visitTypes),
        ]
    );
  }

  List<SpeedDialChild> _startVisitOptions(BuildContext context, List<OmrsVisitType>? visitTypes) {
    if (visitTypes == null || visitTypes.isEmpty) {
      return [];
    }

    return visitTypes.map((visitType) => SpeedDialChild(
      child: const Icon(Icons.start_outlined,color: Colors.white),
      label: visitType.display,
      backgroundColor: Colors.blueAccent,
      onTap: () {
        if (onSelect != null) {
          onSelect!(visitType);
        }
      },
    )).toList();
  }

}