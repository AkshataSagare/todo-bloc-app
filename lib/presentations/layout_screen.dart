import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/presentations/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentations/tabs/calendar/screens/calendar_screen.dart';
import 'package:todo_bloc/presentations/tabs/tasks/screens/tasks_screen.dart';

import 'widgets/dialog_widget.dart' show CreateAndEditTaskDialog;

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(LoadTasks());
    super.initState();
  }

  final List<Widget> _pages = [TasksScreen(), CalendarScreen()];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],

      floatingActionButton: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return state is TodoLoaded
              ? FloatingActionButton(
                  elevation: 1,
                  onPressed: () => _showCreateTaskDialog(),
                  child: Icon(Icons.add_task_rounded),
                )
              : SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateAndEditTaskDialog(
        onSubmit: (task) {
          context.read<TodoBloc>().add(CreateTask(task: task));
    
        },
      ),
    );
  }
}
