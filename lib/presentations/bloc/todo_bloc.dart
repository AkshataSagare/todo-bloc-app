import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/presentations/data/models/task_model.dart';
import 'package:todo_bloc/presentations/data/repositories/todo_repo.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<TaskModel> tasks = [];
  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {});

    on<LoadTasks>((event, emit) async {
      emit(TodoLoading());

      try {
        List<TaskModel> tempTasks = await TodoRepo.getAllTasks();
        tasks = tempTasks;
        emit(TodoLoaded(tasks: tasks));
      } catch (e) {
        log(e.toString());
      }
    });
    on<CreateTask>((event, emit) async {
      try {
        await TodoRepo.saveTask(event.task).then((_) {
          final List<TaskModel> updatedTasks = List<TaskModel>.from(tasks)..add(event.task);
          tasks = updatedTasks;
          emit(TodoLoaded(tasks: updatedTasks));
        });
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
