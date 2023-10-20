// ignore_for_file: unused_local_variable, sized_box_for_whitespace, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, unused_import, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_task/Controllers/create_task_controller.dart';
import 'package:todo_task/Controllers/delete_task_controller.dart';
import 'package:todo_task/Controllers/google_sign_in_controller.dart';
import 'package:todo_task/Controllers/google_sign_out_controller.dart';
import 'package:todo_task/Controllers/update_task_controller.dart';
import 'package:todo_task/Screens/LoginScreen.dart';
import 'package:todo_task/constants/TxtStyles.dart';
import 'package:todo_task/constants/Utils.dart';

import '../constants/Clrs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List data = [];

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GoogleSignoutController googleSignoutController =
        Get.put(GoogleSignoutController());

    DeleteTaskController deleteTaskController = Get.put(DeleteTaskController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(Utils.profilePic.toString()),
            ),
            // CircleAvatar(child: CachedNetworkImage(imageUrl: Utils.profilePic.toString(),fit: BoxFit.contain,),radius: 25,),
            Text(
              Utils.userName.toString(),
              style: TxtStyles.secondaryStyle,
            ),

            const Flexible(child: SizedBox()),

            ElevatedButton(
                onPressed: () async {
                  await googleSignoutController.signOutFromGoogle();

                  Get.off(const LoginPage());
                },
                child: const Text("Logout"))
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            height: size.height * 0.4,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Todo').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                data = snapshot.data!.docs;

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    print('uuid' + auth.currentUser!.uid);

                    if (auth.currentUser!.uid ==
                            snapshot.data!.docs[index]['uid'] &&
                        snapshot.hasData) {
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0.0),
                            title: Text(snapshot.data!.docs[index]['taskname']
                                .toString()),
                            subtitle: Text(
                              snapshot.data!.docs[index]['taskdesc'].toString(),
                            ),
                            leading: Checkbox(
                              value: data[index]["iscompleted"],
                              onChanged: (bool? value) {
                                setState(() {
                                  // Get the reference to the Firestore document
                                  final documentReference =
                                      data[index].reference;

                                  // Update the "iscompleted" field using Firestore's update method
                                  documentReference
                                      .update({"iscompleted": value});
                                });
                              },
                            ),
                            trailing: IconButton(
                                onPressed: (() {
                                  deleteTaskController
                                      .deleteTask(data[index]["docid"]);
                                  if (deleteTaskController.isLoading == false) {
                                    Get.snackbar(
                                        "task deleted successfully", "",
                                        snackPosition: SnackPosition.BOTTOM);
                                    
                                  }
                                }),
                                icon: const Icon(Icons.delete)),
                            selected: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Update Task'),
                                    content: editTaskDetails(
                                        data[index]['taskname'].toString(),
                                        data[index]['taskdesc'].toString(),
                                        data[index]["docid"].toString()),
                                  );
                                },
                              );
                              // _showeditDialog(context,data[index]['taskname'].toString(),data[index]['taskdesc'].toString());
                              // print();
                              //  Navigator.push(context, MaterialPageRoute(builder: (context)=> OperationsPage(data: data,index: index,)));
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.isEmpty &&
                        auth.currentUser!.uid !=
                            snapshot.data!.docs[index]['uid']) {
                      return const SizedBox();
                    } else {
                      return const Text("");
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.file_open),
          onPressed: () {
            _showcreateDialog(context);
          },
        ),
      ),
    );
  }

  void _showcreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: createTaskDetails(),
        );
      },
    );
  }

  Widget createTaskDetails() {
    CreateTaskController createTaskController = Get.put(CreateTaskController());
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: taskNameController,
              style: TxtStyles.taskStyle,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Clrs.greyClr),
                  hintText: "Enter Task Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: taskDescriptionController,
              style: TxtStyles.taskStyle,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Clrs.greyClr),
                  hintText: "Enter Task Description"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                var docid =
                    FirebaseFirestore.instance.collection('Todo').doc().id;
                createTaskController.setData(
                    docid,
                    taskNameController.text.toString(),
                    taskDescriptionController.text.toString());
                if (createTaskController.isLoading == false) {
                  taskNameController.clear();
                  taskDescriptionController.clear();
                  Get.snackbar("task created successfully", "",
                      snackPosition: SnackPosition.BOTTOM);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Task"))
        ],
      ),
    );
  }

  Widget editTaskDetails(String taskname, String taskdesc, String docid) {
    UpdateTaskController updateTaskController = Get.put(UpdateTaskController());
    TextEditingController taskNameEditController =
        TextEditingController(text: taskname);
    TextEditingController taskDescriptionEditController =
        TextEditingController(text: taskdesc);

    CreateTaskController createTaskController = Get.put(CreateTaskController());
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: taskNameEditController,
              style: TxtStyles.taskStyle,
              decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Clrs.greyClr),
                  hintText: taskname.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: taskDescriptionEditController,
              style: TxtStyles.taskStyle,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Clrs.greyClr),
                hintText: taskdesc.toString(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                updateTaskController.updateTask(
                    docid,
                    taskNameEditController.text.toString(),
                    taskDescriptionEditController.text.toString());

                if (updateTaskController.isLoading == false) {
                  taskNameEditController.clear();
                  taskDescriptionEditController.clear();
                  Get.snackbar("task updated successfully", "",
                      snackPosition: SnackPosition.BOTTOM);
                  Navigator.pop(context);
                }
              },
              child: const Text("Update Task"))
        ],
      ),
    );
  }
}
