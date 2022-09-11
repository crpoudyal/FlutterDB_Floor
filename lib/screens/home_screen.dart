import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterdb/DAO/user_dao.dart';
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
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<FlutterDatabase>(
        future: $FloorFlutterDatabase.databaseBuilder('users.db').build(),
        builder: (context, data) {
          if (data.hasData) {
            final FlutterDatabase database = data.data!;
            final userDao = database.userDao;
            return StreamBuilder<List<User>>(
              stream: userDao.findAllUser(),
              builder: (context, snapshot) {
                log("Snapshot data------>" + snapshot.toString());
                if (snapshot.hasData) {
                  final List<User> userList = snapshot.data!;
                  return buildUserList(userList);
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

  Widget buildUserList(List<User> userList) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        log("userlist----->" + userList.toString());
        log("userlength------>" + userList.length.toString());
        return ListTile(
          title: Text(userList[index].firstName ?? "[FirstName]"),
          subtitle: Text(userList[index].lastName ?? "[LastName]"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final deleteUser = userList[index];
              log("User Index ---- > " + userList[index].toString());
              final userDao = database?.userDao;
              await userDao?.deleteUser(deleteUser);
            },
          ),
        );
      },
    );
    // return ListView(
    //   children: userList
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
                final user = User(firstname, lastname);

                await userDao?.insertUser(user);
                setState(() {});

                print(firstname + lastname);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
