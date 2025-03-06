import 'package:flutter/material.dart';

Future<bool> showExitWarning(BuildContext context) async {
  return await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Exit App"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Yes"),
                ),
              ],
            ),
      ) ??
      false;
}
