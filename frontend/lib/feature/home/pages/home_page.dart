import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/feature/home/widgets/task_card.dart';

import '../widgets/date_selector.dart';
import 'add_new_task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Column(
        children: [
          const DateSelector(),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                  color: Color.fromRGBO(246, 222, 194, 1),
                  headerText: "headerText",
                  descriptionText:
                      "descriptionText, descriptionText, descriptionTextdescriptionTextdescriptionTextdescriptionText descriptionTextdescriptionTextdescriptionText descriptionTextdescriptionTextdescriptionText",
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: strengthenColor(
                      const Color.fromRGBO(246, 222, 194, 1),
                      0.69,
                    ),
                    shape: BoxShape.circle),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "10:00 AM",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
