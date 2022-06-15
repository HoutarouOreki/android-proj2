import 'package:flutter/material.dart';

import 'telefon.dart';

class TelefonListElement extends StatelessWidget {
  final Telefon telefon;

  final void Function()? onPressed;

  const TelefonListElement({Key? key, required this.telefon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 20)),
        onPressed: onPressed,
        child: Column(
          children: [
            Text(
              telefon.model,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(telefon.producent),
          ],
        ),
      ),
    );
  }
}
