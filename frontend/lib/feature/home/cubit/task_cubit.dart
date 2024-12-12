import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/feature/home/repository/task_local_repository.dart';
import 'package:frontend/feature/home/repository/task_remote_repository.dart';

import '../../../model/task_model.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Taskinitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TaskLoading());
      final task = await taskRemoteRepository.createTask(
          uid: uid,
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt);
      await taskLocalRepository.insertTask(task);
      emit(AddNewTaskSucess(task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      emit(TaskLoading());
      final task = await taskRemoteRepository.getTasks(token: token);
      emit(GetTasksSucess(task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
