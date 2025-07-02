part of 'todo_bloc.dart';

sealed class TodoEvent {}

final class CreateTask extends TodoEvent {
  final TaskModel task;

  CreateTask({required this.task});
}

final class LoadTasks extends TodoEvent {
  LoadTasks();
}