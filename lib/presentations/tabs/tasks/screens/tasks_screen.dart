import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/snackbars.dart';
import '../../../bloc/todo_bloc.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/task_model.dart';
import '../../../widgets/delete_dialog_widget.dart';
import '../../../widgets/dialog_widget.dart';
import '../../../widgets/filter_bottom_sheet.dart';
import '../../../widgets/sort_bottom_sheet.dart';
import '../../../widgets/task_tile_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Sorting _selectedSorting = Sorting.title;
  bool _isAscending = true;
  Set<Priority> _selectedPriorities = {};

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
                          onPressed: () => _showSortBottomSheet(context),
                          icon: Icon(Icons.sort),
                          label: Text('Sort by: ${_getSortingText()}'),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () => _showFilterBottomSheet(context),
                          icon: Icon(Icons.filter_alt),
                          label: Text('Filter ${_getFilterText()}'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sortAndFilter(state.tasks).length,
                      itemBuilder: (context, index) => TaskTile(
                        key: ValueKey(state.tasks[index].id),
                        task: _sortAndFilter(state.tasks)[index],
                        onToggleComplete: () => context.read<TodoBloc>().add(
                          MarkTaskAsComplete(
                            task: _sortAndFilter(state.tasks)[index],
                          ),
                        ),
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => CreateAndEditTaskDialog(
                            taskModel: _sortAndFilter(state.tasks)[index],
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
                            taskTitle: _sortAndFilter(state.tasks)[index].title,
                            onDelete: () => context.read<TodoBloc>().add(
                              DeleteTask(
                                task: _sortAndFilter(state.tasks)[index],
                              ),
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

  List<TaskModel> _sortAndFilter(List<TaskModel> tasks) {
    List<TaskModel> updatedTasks = List.from(tasks);

    if (_selectedPriorities.isNotEmpty) {
      updatedTasks = updatedTasks
          .where((task) => _selectedPriorities.contains(task.priority))
          .toList();
    }

    switch (_selectedSorting) {
      case Sorting.title:
        updatedTasks.sort(
          (a, b) => _isAscending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title),
        );
        break;
      case Sorting.dueDate:
        updatedTasks.sort(
          (a, b) => _isAscending
              ? a.date.compareTo(b.date)
              : b.date.compareTo(a.date),
        );
        break;
      case Sorting.creationDate:
        updatedTasks.sort(
          (a, b) => _isAscending
              ? a.createdOn.compareTo(b.createdOn)
              : b.createdOn.compareTo(a.createdOn),
        );
        break;
      case Sorting.priority:
        updatedTasks.sort(
          (a, b) => _isAscending
              ? a.priority.index.compareTo(b.priority.index)
              : b.priority.index.compareTo(a.priority.index),
        );
        break;
    }
    return updatedTasks;
  }

  String _getSortingText() {
    String order = _isAscending ? "↑" : "↓";
    switch (_selectedSorting) {
      case Sorting.title:
        return 'Title $order';
      case Sorting.dueDate:
        return 'Due Date $order';
      case Sorting.creationDate:
        return 'Created $order';
      case Sorting.priority:
        return 'Priority $order';
    }
  }

  String _getFilterText() {
    if (_selectedPriorities.isEmpty) {
      return '(All)';
    }
    return '(${_selectedPriorities.length})';
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottomSheet(
        currentSorting: _selectedSorting,
        isAscending: _isAscending,
        onApply: (sorting, isAscending) {
          setState(() {
            _selectedSorting = sorting;
            _isAscending = isAscending;
          });
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        selectedPriorities: _selectedPriorities,
        onApply: (priorities) {
          setState(() {
            _selectedPriorities = priorities;
          });
        },
      ),
    );
  }
}



