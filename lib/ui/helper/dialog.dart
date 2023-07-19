import 'package:flutter/material.dart';

import '../../data/players_dao.dart';

AddPlayerDialog(BuildContext context, String text, PlayerDao playerDao) {
  TextEditingController controller = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(text),
          content: TextField(
            controller: controller,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: <Widget>[
            MaterialButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              elevation: 5.0,
              onPressed: () {
                if (controller.text != "") {
                  Navigator.of(context).pop(controller.text.toString());
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text('ADD PLAYER'),
            )
          ],
        );
      });
}
