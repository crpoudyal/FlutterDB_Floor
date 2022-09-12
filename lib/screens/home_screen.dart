import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterdb/db/database.dart';
import 'package:flutterdb/entity/user.dart';

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
    // return ListView(
    //   children: userLists
    //       .map((item) => ListTile(
    //             title: Text(item.firstName),
    //             subtitle: Text(item.lastName),
    //             trailing: IconButton(
    //               icon: const Icon(Icons.delete),
    //               onPressed: () {},
    //             ),
    //           ))
    //       .toList(),
    // );
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

                Navigator.of(context).pop();
                const snackBar = SnackBar(
                  content: Text("new user added"),
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
}
