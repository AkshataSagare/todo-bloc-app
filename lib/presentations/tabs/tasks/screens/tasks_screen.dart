import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/snackbars.dart';
import '../../../bloc/todo_bloc.dart';
import '../../../widgets/delete_dialog_widget.dart';
import '../../../widgets/dialog_widget.dart';
import '../../../widgets/task_tile_widget.dart';

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
        listener: (context, state) {
          if (state is TodoLoaded) {
            if (state.successMessage != null) {
              CustomSnackbar.showSuccess(
                context: context,
                message: state.successMessage!,
              );
            }
            if (state.errorMessage != null) {
              CustomSnackbar.showError(
                context: context,
                message: state.errorMessage!,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is TodoLoading || state is TodoInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Text('No tasks, create one and get started'),
              );
            }
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.sort),
                          label: Text('Sort by: Title'),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.star_rate_rounded),
                          label: Text('Priority: HIGH MED LOW'),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
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
                              context.read<TodoBloc>().add(
                                EditTask(task: task),
                              );
                            },
                          ),
                        ),
                        onDelete: () => showDialog(
                          context: context,
                          builder: (context) => DeleteTaskConfirmationDialog(
                            taskTitle: state.tasks[index].title,
                            onDelete: () => context.read<TodoBloc>().add(
                              DeleteTask(task: state.tasks[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
