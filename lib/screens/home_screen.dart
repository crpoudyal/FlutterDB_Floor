import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterdb/db/database.dart';
import 'package:flutterdb/entity/user.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  FlutterDatabase? database;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floor DB"),
        actions: [
          IconButton(
            onPressed: () {
              openDialog();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<FlutterDatabase>(
        future: $FloorFlutterDatabase.databaseBuilder('users.db').build(),
        builder: (context, data) {
          if (data.hasData) {
            database = data.data!;
            final userDao = database!.userDao;
            return StreamBuilder<List<User>>(
              stream: userDao.findAllUser(),
              builder: (context, snapshot) {
                log("Snapshot data" + snapshot.toString());
                if (snapshot.hasData) {
                  log("Inside snapshort--------__--");
                  final List<User>? userList = snapshot.data;
                  return buildUserList(userList!);
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error encountered"),
                  );
                } else {
                  return const Center(
                    child: Text("No Data Found"),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUserList(List<User> userLists) {
    return ListView.builder(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: userLists.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialogForUpdate();
            },
          ),
          title: Text(userLists[index].firstName),
          subtitle: Text(userLists[index].lastName),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final userDao = database?.userDao;
              await userDao?.deleteUser(userLists[index]);
              final snackBar = SnackBar(
                content: Text("${userLists[index].firstName} is deleted"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        );
      },
    );
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Information"),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter First Name',
                ),
              ),
              TextField(
                controller: _lastNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Last Name',
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                String firstname = _firstNameController.text;
                String lastname = _lastNameController.text;

                final userDao = database?.userDao;
                final user = User(firstName: firstname, lastName: lastname);

                await userDao?.insertUser(user);
                Get.back();
                var snackBar = SnackBar(
                  content: Text('$firstname added'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _firstNameController.clear();
                _lastNameController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDialogForUpdate() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Update Information"),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter First Name',
                      ),
                    ),
                    TextField(
                      controller: _lastNameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Last Name',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    child: const Text("Update"),
                    onPressed: () async {
                      String firstname = _firstNameController.text;
                      String lastname = _lastNameController.text;

                      final userDao = database?.userDao;
                      final users =
                          User(firstName: firstname, lastName: lastname);

                      await userDao?.updateUser(users);

                      Get.back();
                      var snackBar = SnackBar(
                        content: Text("$firstname updated"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _firstNameController.clear();
                      _lastNameController.clear();
                    },
                  ),
                ),
              ],
            ));
  }
}
