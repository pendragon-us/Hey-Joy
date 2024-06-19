import 'package:flutter/material.dart';
import 'package:hey_joy_application/data/user_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDialog extends StatefulWidget {
  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return AlertDialog(
      title: Text('Type the note here'),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(hintText: 'Enter text here'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Save'),
          onPressed: () async {
            setState(() {
              String editedText = textEditingController.text;
              UserPref.setNote(editedText);
            });
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}