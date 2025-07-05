part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {
  const TodoInitial();
}

final class TodoLoading extends TodoState {
  const TodoLoading();
}

final class TodoLoaded extends TodoState {
  final List<TaskModel> tasks;
  final String? successMessage;
  final String? errorMessage;
  const TodoLoaded({
    this.successMessage,
    this.errorMessage,
    required this.tasks,
  });

  @override
  List<Object> get props => [tasks];
}
