import 'package:flutter/material.dart';
import 'package:habittute/models/app_settings.dart';
import 'package:habittute/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
    S E T U P
  */

  // I N I T - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
    C R U D
  */

  // list of habits
  final List<Habit> currentHabits = [];

  // create habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from db
    getHabits();
  }

  // read habit
  Future<void> getHabits() async {
    // fetch all habits from db
    List<Habit> fetchHabits = await isar.habits.where().findAll();

    // give to current habits list
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    // update UI
    notifyListeners();
  }

  // update habit on or off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find spesific habit
    final habit = await isar.habits.get(id);

    // update complete status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add the current date to completed days list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          // add the current date if its not alrerady in the list
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.second == DateTime.now().second,
          );
        }

        // save the updated habit back to db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    getHabits();
  }

  // update name of habit
  Future<void> updateHabitName(int id, String newName) async {
    // find spesific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;
        // save updated habit to db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    getHabits();
  }

  // delete habit
  Future<void> deleteHabit(int id) async {
    // find spesific habit
    final habit = await isar.habits.get(id);


    if (habit != null) {
      await isar.writeTxn(() async {
        await isar.habits.delete(id);
      });
    }
    getHabits();
  }
}
