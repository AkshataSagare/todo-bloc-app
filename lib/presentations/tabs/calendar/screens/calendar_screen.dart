import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_bloc/presentations/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentations/data/models/task_model.dart';

import '../../../widgets/dialog_widget.dart';
import '../../../widgets/task_tile_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();

  DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Map<DateTime, int> getTaskCountMap(List<TaskModel> tasks) {
    final map = <DateTime, int>{};
    for (var task in tasks) {
      final date = normalizeDate(task.date);
      map[date] = (map[date] ?? 0) + 1;
    }
    return map;
  }

  List<TaskModel> getTaskOfDay(List<TaskModel> tasks) {
    return tasks
        .where(
          (task) =>
              DateTime(task.date.year, task.date.month, task.date.day) ==
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading || state is TodoInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              final taskCountMap = getTaskCountMap(state.tasks);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TableCalendar(
                      currentDay: selectedDay,
                      firstDay: DateTime(2020),
                      lastDay: DateTime(3000),
                      focusedDay: selectedDay,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      onDaySelected: (d, focusedDay) {
                        setState(() {
                          selectedDay = focusedDay;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final count = taskCountMap[normalizeDate(day)];
                          if (count != null && count > 0) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      '${day.day}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        count > 99 ? '99+' : '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: getTaskOfDay(state.tasks).isEmpty
                        ? Center(child: Text('No tasks for today'))
                        : ListView.builder(
                            itemCount: getTaskOfDay(state.tasks).length,
                            itemBuilder: (context, index) => TaskTile(
                              task: getTaskOfDay(state.tasks)[index],
                              onToggleComplete: () =>
                                  context.read<TodoBloc>().add(
                                    MarkTaskAsComplete(
                                      task: getTaskOfDay(state.tasks)[index],
                                    ),
                                  ),
                              onEdit: () => showDialog(
                                context: context,
                                builder: (context) => CreateAndEditTaskDialog(
                                  taskModel: getTaskOfDay(state.tasks)[index],
                                  onSubmit: (task) {
                                    context.read<TodoBloc>().add(
                                      EditTask(task: task),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
