import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/presentations/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentations/widgets/task_tile_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TodoLoading || state is TodoInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) =>
                  TaskTile(task: state.tasks[index]),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
