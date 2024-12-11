import 'dart:convert';
import 'dart:developer';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/model/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  Future<TaskModel> createTask(
      {required String title,
      required String description,
      required String hexColor,
      required String token,
      required DateTime dueAt}) async {
    final body = jsonEncode({
      "title": title,
      "description": description,
      "hexColor": hexColor,
      "dueAt": dueAt.toIso8601String()
    });
    log(body);
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/task"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: body,
      );
      log(res.body);
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getTask() async {}
  Future<void> deleteTask() async {}
}
