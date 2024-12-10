import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<UserModel> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final body =
          jsonEncode({"name": name, "email": email, "password": password});
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final body = jsonEncode({"email": email, "password": password});
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
