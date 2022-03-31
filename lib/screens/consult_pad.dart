import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/models/consultation_model.dart';

class ConsultPadWidget extends StatefulWidget {
  const ConsultPadWidget({
    Key? key,
    this.patientUuid,
  }) : super(key: key);

  final Color color = const Color(0xFFFFE306);
  final String? patientUuid;

  @override
  State<ConsultPadWidget> createState() => _ConsultPadWidgetState();
}

class _ConsultPadWidgetState extends State<ConsultPadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
            ),
            child: Consumer<ConsultationModel>(
              builder: (context, consultation, child) {
                return Column(
                  children: [
                    _showInfo(consultation, context)
                  ],
                );
              },
            ),
          );
  }

  Text _showInfo(ConsultationModel consultation, BuildContext context) {
    var startTime = DateFormat('dd-MMM-yyy, hh:mm a').format(consultation.startTime);
    var display = consultation.consultationInitiated ? 'Draft ($startTime)' : 'None';
    return Text('Session: $display', style: Theme.of(context).textTheme.bodyText1,);
  }
}

class ConsultationActions extends StatelessWidget {
  const ConsultationActions({Key? key}) : super(key: key);
  final FloatingActionButtonLocation fabLocation = FloatingActionButtonLocation.endDocked;
  final NotchedShape shape = const CircularNotchedRectangle();

  static final List<FloatingActionButtonLocation> centerLocations =
  <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blueGrey,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Consult',
              icon: const Icon(Icons.new_releases_sharp),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Investigations',
              icon: const Icon(Icons.add_chart_rounded),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Condition',
              icon: const Icon(Icons.add_to_photos_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
