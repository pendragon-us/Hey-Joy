import 'package:flutter/material.dart';

import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.titleController,
    required this.onSave,
    required this.onCancel,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xfffaeaff),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // save and cancel icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onCancel,
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                IconButton(
                    onPressed: onSave,
                    icon: Icon(Icons.done)
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  // Text Field for enter title of the task
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title...",
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text Field for enter content of the task
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: "Content...",
                    ),
                    maxLines: 10,
                    minLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
