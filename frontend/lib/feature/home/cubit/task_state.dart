part of 'task_cubit.dart';

sealed class TaskState {
  const TaskState();
}

final class Taskinitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskError extends TaskState {
  final String error;

  const TaskError(this.error);
}

final class AddNewTaskSucess extends TaskState {
  final TaskModel task;

  const AddNewTaskSucess(this.task);
}

final class GetTasksSucess extends TaskState {
  final List<TaskModel> tasks;

  const GetTasksSucess(this.tasks);
}
