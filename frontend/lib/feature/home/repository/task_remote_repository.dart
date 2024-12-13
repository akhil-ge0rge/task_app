import 'dart:convert';
import 'dart:developer';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/model/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'task_local_repository.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();
  Future<TaskModel> createTask(
      {required String title,
      required String description,
      required String hexColor,
      required String token,
      required String uid,
      required DateTime dueAt}) async {
    final body = jsonEncode({
      "title": title,
      "description": description,
      "hexColor": hexColor,
      "dueAt": dueAt.toIso8601String()
    });
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/task"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: body,
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      log("ERR ON 1st catch");
      try {
        final task = TaskModel(
          id: const Uuid().v4(),
          uid: uid,
          title: title,
          description: description,
          color: hexToRgb(hexColor),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(task);
        return task;
      } catch (e) {
        log("ERR ON 2nd catch");
        log(e.toString());
        rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/task"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      log(res.body);
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }
      final listOfTask = jsonDecode(res.body);
      List<TaskModel> taskList = [];

      for (var element in listOfTask) {
        log(element.toString());
        taskList.add(TaskModel.fromMap(element));
      }

      await taskLocalRepository.insertTasks(taskList);

      return taskList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }

  Future<bool> syncTasks({
    required List<TaskModel> tasks,
    required String token,
  }) async {
    try {
      final taskList = [];
      for (final task in tasks) {
        taskList.add(task.toMap());
      }
      final body = jsonEncode(taskList);
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/task/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: body,
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteTask() async {}
}
