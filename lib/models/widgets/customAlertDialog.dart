import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String posText;
  final String negText;
  final Function posAction;
  final Function? negAction;
  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.posText,
      required this.negText,
      required this.posAction,
      this.negAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).focusColor),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      elevation: 5,
      title: Text(title),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).focusColor),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodyMedium)),
          onPressed: (negAction == null)
              ? () {
                  Navigator.of(context).pop();
                }
              : () => negAction!(),
          child: Text(negText),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.bodyMedium),
          ),
          onPressed: () => posAction(),
          child: Text(posText),
        ),
      ],
    );
  }
}
