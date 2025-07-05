import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/presentations/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentations/widgets/delete_dialog_widget.dart';
import 'package:todo_bloc/presentations/widgets/task_tile_widget.dart';

import '../../../widgets/dialog_widget.dart';

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
              itemBuilder: (context, index) => TaskTile(
                key: ValueKey(state.tasks[index].id),
                task: state.tasks[index],
                onToggleComplete: () => context.read<TodoBloc>().add(
                  MarkTaskAsComplete(task: state.tasks[index]),
                ),
                onEdit: () => showDialog(
                  context: context,
                  builder: (context) => CreateAndEditTaskDialog(
                    taskModel: state.tasks[index],
                    onSubmit: (task) {
                      context.read<TodoBloc>().add(EditTask(task: task));
                    },
                  ),
                ),
                onDelete: () => showDialog(
                  context: context,
                  builder: (context) => DeleteTaskConfirmationDialog(
                    taskTitle: state.tasks[index].title,
                    onDelete: () =>
                      context.read<TodoBloc>().add(DeleteTask(task: state.tasks[index] ))
                    
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
