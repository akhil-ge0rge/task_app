import 'dart:developer';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/feature/auth/cubit/auth_cubit.dart';
import 'package:frontend/feature/home/cubit/task_cubit.dart';
import 'package:frontend/feature/home/pages/home_page.dart';
import 'package:intl/intl.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  final formKey = GlobalKey<FormState>();

  void createTask() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<TaskCubit>().createNewTask(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          color: selectedColor,
          token: user.userModel.token,
          uid: user.userModel.id,
          dueAt: selectedDate);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        actions: [
          GestureDetector(
            onTap: () async {
              final _selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
              );
              if (_selectedDate != null) {
                setState(() {
                  selectedDate = _selectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat('d-MM-y').format(selectedDate)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            log(state.error);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AddNewTaskSucess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Task Added")));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Description",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ColorPicker(
                      heading: const Text("Select Color"),
                      subheading: const Text("Select a Diffrent Shade"),
                      pickersEnabled: const {
                        ColorPickerType.wheel: true,
                      },
                      color: selectedColor,
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: createTask,
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
