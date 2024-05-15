
import 'package:flutter/material.dart';

class ProfileHeading extends StatelessWidget {
  final String title;
  const ProfileHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add_alt_1_rounded),
              title: Text(title),
              subtitle: Text(''),
            )
          ],
        )
    );
  }
}