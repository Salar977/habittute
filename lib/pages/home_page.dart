import 'package:flutter/material.dart';
import 'package:habittute/components/my_drawer.dart';
import 'package:habittute/components/my_habit_tile.dart';
import 'package:habittute/components/my_heat_map.dart';
import 'package:habittute/database/habit_database.dart';
import 'package:habittute/models/habit.dart';
import 'package:habittute/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // init state
  @override
  void initState() {
    // read existing habit on app startup
    Provider.of<HabitDatabase>(context, listen: false).getHabits();

    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  void createNewHabbit() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Create a new habit"),
            ),
            actions: [
              // save button
              MaterialButton(
                onPressed: () {
                  // get the habit name
                  String habitName = textController.text;

                  // save to db
                  context.read<HabitDatabase>().addHabit(habitName);

                  // pop box
                  Navigator.pop(context);

                  // clear controller
                  textController.clear();
                },
                child: const Text("Save"),
              ),

              // cancel button
              MaterialButton(
                onPressed: () {
                  // pop box
                  Navigator.pop(context);

                  // clear controller
                  textController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  // check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update the habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Edit habit name"),
            ),
            actions: [
              // save button
              MaterialButton(
                onPressed: () {
                  // get the habit name
                  String habitName = textController.text;

                  // save to db
                  context.read<HabitDatabase>().updateHabitName(
                    habit.id,
                    habitName,
                  );

                  // pop box
                  Navigator.pop(context);

                  // clear controller
                  textController.clear();
                },
                child: const Text("Save"),
              ),

              // cancel button
              MaterialButton(
                onPressed: () {
                  // pop box
                  Navigator.pop(context);

                  // clear controller
                  textController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  // delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: const Text('Are you sure?'),
            actions: [
              // Delete button
              MaterialButton(
                onPressed: () {
                  // delete from db
                  context.read<HabitDatabase>().deleteHabit(habit.id);

                  // pop box
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),

              // cancel button
              MaterialButton(
                onPressed: () {
                  // pop box
                  Navigator.pop(context);

                  // clear controller
                  textController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Habitute',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabbit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          // heat map
          _buildHeatMap(),

          // habitList
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder:(context, snapshot) {
        // once the data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabits),
          );
        }
        // handle case where no data is returned
        else {
          return Container(

          );
        }

      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return Tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          onEdit: (context) => editHabitBox(habit),
          onDelete: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
