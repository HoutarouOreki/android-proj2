import 'package:flutter/material.dart';
import 'package:proj2/telefon_formularz.dart';
import 'package:proj2/telefony_db.dart';

import 'telefon.dart';
import 'telefon_list_element.dart';

class TelefonList extends StatefulWidget {
  const TelefonList({Key? key}) : super(key: key);

  @override
  State<TelefonList> createState() => _TelefonListState();
}

class _TelefonListState extends State<TelefonList> {
  final _telefonyDb = TelefonyDb();
  List<Telefon> telefony = <Telefon>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    odswiez();
  }

  Future odswiez() async {
    setState(() => isLoading = true);
    telefony = await (_telefonyDb).telefons();
    setState(() => isLoading = false);
  }

  void handleClick(String value) async {
    setState(() => isLoading = true);
    for (var telefon in telefony) {
      await _telefonyDb.deleteTelefon(telefon.id);
    }
    if (value == 'Zresetuj bd') {
      for (var telefon in _telefonyDb.utworzPrzykladoweTelefony()) {
        await (_telefonyDb).insertPhone(telefon);
      }
    }
    odswiez();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projekt 2"),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (context) {
              return {"Zresetuj bd", "Usuń wszystkie"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              for (var telefon in telefony)
                Column(
                  children: [
                    TelefonListElement(
                      telefon: telefon,
                      onPressed: () {
                        przejdzDoEdycji(telefon);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: przejdzDoDodawania,
        tooltip: 'Dodaj telefon',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> przejdzDoDodawania() async {
    final Telefon? nowyTelefon = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TelefonFormularz()));
    if (nowyTelefon != null) {
      if (telefony.isEmpty) {
        nowyTelefon.id = 1;
      } else {
        telefony.sort((a, b) => a.id.compareTo(b.id));
        nowyTelefon.id = telefony.last.id + 1;
      }
      await _telefonyDb.insertPhone(nowyTelefon);
    }
    odswiez();
  }

  Future<void> przejdzDoEdycji(Telefon telefon) async {
    final dynamic nowyTelefon = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TelefonFormularz(
          telefon: telefon,
        ),
      ),
    );
    if (nowyTelefon == true) {
      // usun
      _telefonyDb.deleteTelefon(telefon.id);
      await odswiez();
      return;
    }
    if (nowyTelefon != null) {
      nowyTelefon.id = telefon.id;
      await _telefonyDb.insertPhone(nowyTelefon);
    }
    odswiez();
  }
}
