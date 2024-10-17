import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/tasks_controller.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tasksController = Get.put(TasksController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.showDailyTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                var taskName = task['task_name']; // Assuming 'task_name' field exists
                var url = task['url']; // Assuming 'url' field exists
                bool isCompleted = (task['completed'] as List<dynamic>).contains(userTelegramId.toString());
                return ListTile(
                  title: Text(taskName,),
                  trailing: isCompleted == true ? Icon(Icons.check) : IconButton(
                    icon: Icon(Icons.open_in_browser),
                    onPressed: () async {
                      if (await canLaunch(url)) {
                        await launch(url).then((value){
                          tasksController.markTasksCompleted(userId: userTelegramId.toString(), context: context,docId: task.id);
                        });

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open $url')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No tasks found'));
          }
        },
      ),
    );
  }
}
