import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/feature/home/cubit/task_cubit.dart';
import 'package:frontend/feature/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../widgets/date_selector.dart';
import 'add_new_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TaskCubit>().getAllTasks(token: user.userModel.token);
    Connectivity().onConnectivityChanged.listen(
      (data) async {
        if (data.contains(ConnectivityResult.wifi)) {
          log("CONNECTED TO WIFI");
          if (mounted) {
            log("haloo");
            await context
                .read<TaskCubit>()
                .syncTasks(token: user.userModel.token);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddNewTask(),
              ));
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is TaskError) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is GetTasksSucess) {
            final tasks = state.tasks
                .where(
                  (element) =>
                      DateFormat('d').format(element.dueAt) ==
                          DateFormat('d').format(selectedDate) &&
                      selectedDate.month == element.dueAt.month &&
                      selectedDate.year == element.dueAt.year,
                )
                .toList();

            return Column(
              children: [
                DateSelector(
                  selectedDate: selectedDate,
                  onTap: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks.elementAt(index);
                        log(task.toString());
                        return Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: task.color,
                                headerText: task.title,
                                descriptionText: task.description,
                              ),
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: strengthenColor(
                                    task.color,
                                    0.69,
                                  ),
                                  shape: BoxShape.circle),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(task.dueAt),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
