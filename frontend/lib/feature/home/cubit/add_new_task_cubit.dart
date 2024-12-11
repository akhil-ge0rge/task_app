import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/feature/home/repository/task_remote_repository.dart';

import '../../../model/task_model.dart';
part 'add_new_task_state.dart';

class AddNewTaskCubit extends Cubit<AddNewTaskState> {
  AddNewTaskCubit() : super(AddNewTaskinitial());
  final taskRemoteRepository = TaskRemoteRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(AddNewTaskLoading());
      final task = await taskRemoteRepository.createTask(
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt);
      emit(AddNewTaskSucess(task));
    } catch (e) {
      emit(AddNewTaskError(e.toString()));
    }
  }
}
