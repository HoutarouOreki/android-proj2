import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proj2/full_width_button.dart';
import 'package:proj2/telefon.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TelefonFormularz extends StatefulWidget {
  final Telefon? telefon;

  const TelefonFormularz({this.telefon, Key? key}) : super(key: key);

  @override
  State<TelefonFormularz> createState() => _TelefonFormularzState();
}

class _TelefonFormularzState extends State<TelefonFormularz> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController producentController = TextEditingController();
  final TextEditingController stronaWwwController = TextEditingController();
  final TextEditingController wersjaController = TextEditingController();

  String wyswietlBladToastOrazPrzekaz(String t) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t)),
    );
    return t;
  }

  @override
  Widget build(BuildContext context) {
    modelController.text = widget.telefon?.model ?? "";
    producentController.text = widget.telefon?.producent ?? "";
    stronaWwwController.text = widget.telefon?.stronaWww ?? "";
    wersjaController.text = widget.telefon?.wersjaAndroida ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj telefon"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: producentController,
                decoration: const InputDecoration(labelText: "Producent"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return wyswietlBladToastOrazPrzekaz("Podaj producenta");
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: "Model"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return wyswietlBladToastOrazPrzekaz("Podaj model");
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stronaWwwController,
                decoration: const InputDecoration(labelText: "Strona WWW"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return wyswietlBladToastOrazPrzekaz(
                        "Podaj stronę WWW telefonu");
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: wersjaController,
                decoration: const InputDecoration(labelText: "Wersja Androida"),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return wyswietlBladToastOrazPrzekaz(
                        'Podaj wersję Androida.');
                  }
                  int? liczba = int.tryParse(value);
                  if (liczba == null) {
                    return wyswietlBladToastOrazPrzekaz(
                        'Podaj wersję Androida');
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox.fromSize(size: const Size(0, 20)),
              FullWidthButton(
                onPressed: () {
                  zwrocTelefon();
                },
                child: const Text("Zapisz"),
              ),
              FullWidthButton(
                onPressed: () async {
                  if (!await canLaunchUrlString(stronaWwwController.text)) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Podaj prawidłowy link, zaczynający się od https://")),
                    );
                    return;
                  }
                  await launchUrlString(stronaWwwController.text);
                },
                child: const Text("Otwórz stronę"),
              ),
              if (widget.telefon != null)
                FullWidthButton(
                  primary: Colors.red,
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Usuń"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void zwrocTelefon() {
    if (_formKey.currentState!.validate()) {
      var telefon = Telefon(0, producentController.text, modelController.text,
          wersjaController.text, stronaWwwController.text);
      Navigator.of(context).pop(telefon);
    }
  }
}
