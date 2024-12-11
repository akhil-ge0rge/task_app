part of 'add_new_task_cubit.dart';

sealed class AddNewTaskState {
  const AddNewTaskState();
}

final class AddNewTaskinitial extends AddNewTaskState {}

final class AddNewTaskLoading extends AddNewTaskState {}

final class AddNewTaskError extends AddNewTaskState {
  final String error;

  const AddNewTaskError(this.error);
}

final class AddNewTaskSucess extends AddNewTaskState {
  final TaskModel task;

  const AddNewTaskSucess(this.task);
}
