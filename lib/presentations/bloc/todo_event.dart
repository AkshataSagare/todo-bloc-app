part of 'todo_bloc.dart';

sealed class TodoEvent {}

final class CreateTask extends TodoEvent {
  final TaskModel task;

  CreateTask({required this.task});
}

final class LoadTasks extends TodoEvent {
  LoadTasks();
}

final class MarkTaskAsComplete extends TodoEvent{
  final TaskModel task;

  MarkTaskAsComplete({required this.task});
}