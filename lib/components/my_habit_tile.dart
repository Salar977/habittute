import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onDelete;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // edit button
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            // delete button
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            onChanged!(!isCompleted);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? Colors.green
                      : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8)
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted
                  ?
                  Colors.white : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                checkColor: Colors.white,
                activeColor: Colors.blue,
              ),
            )
          ),
        ),
      ),
    );
  }
}
