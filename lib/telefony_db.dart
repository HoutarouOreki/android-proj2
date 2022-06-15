// Define a function that inserts Telefon into the database
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'telefon.dart';

class TelefonyDb {
  Future<Database>? database;
  bool initialized = false;

  List<Telefon> utworzPrzykladoweTelefony() {
    return [
      Telefon(1, "Samsung", "Galaxy S22 Ultra", "13",
          "https://www.tomsguide.com/reviews/samsung-galaxy-s22-ultra"),
      Telefon(2, "Samsung", "Galaxy A53", "12",
          "https://www.tomsguide.com/reviews/samsung-galaxy-a53"),
      Telefon(3, "OnePlus", "10 Pro", "15",
          "https://www.tomsguide.com/reviews/oneplus-10-pro"),
      Telefon(4, "Google", "Pixel 6 Pro", "14",
          "https://www.tomsguide.com/reviews/google-pixel-6-pro"),
    ];
  }

  Future<void> insertPhone(Telefon telefon) async {
    if (!initialized) {
      await _init();
    }
    // Get a reference to the database.
    final db = await database!;

    // Insert the Telefon into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'telefony',
      telefon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTelefon(int id) async {
    if (!initialized) {
      await _init();
    }
    // Get a reference to the database.
    final db = await database!;

    // Remove the Telefon from the database.
    await db.delete(
      'telefony',
      // Use a `where` clause to delete a specific Telefon.
      where: 'id = ?',
      // Pass the Telefon's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

// A method that retrieves all the Telefony from the telefony table.
  Future<List<Telefon>> telefons() async {
    if (!initialized) {
      await _init();
    }

    // Get a reference to the database.
    final db = await database!;

    // Query the table for all The Telefony.
    final List<Map<String, dynamic>> maps = await db.query('telefony');

    // Convert the List<Map<String, dynamic> into a List<Telefon>.
    return List.generate(maps.length, (i) {
      return Telefon(maps[i]['id'], maps[i]['producent'], maps[i]['model'],
          maps[i]['wersjaAndroida'], maps[i]['stronaWww']);
    });
  }

  Future<void> _init() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
        join(await getDatabasesPath(), 'telefony_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE telefony(id INTEGER PRIMARY KEY, producent TEXT, model TEXT, wersjaAndroida TEXT, stronaWww TEXT);',
          );
        }, version: 1);
    initialized = true;
  }
}
