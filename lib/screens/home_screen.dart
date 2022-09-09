import 'package:floor/floor.dart';
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
  late FlutterDatabase database;

  @override
  void initState() {
    // initDatabase();
    super.initState();
  }

  Future<void> initDatabase() async {
    database = await $FloorFlutterDatabase.databaseBuilder('user.db').build();
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
              icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<FlutterDatabase>(
        future: $FloorFlutterDatabase.databaseBuilder('user.db').build(),
        builder: (context, data) {
          if (data.hasData && data.data != null) {
            final FlutterDatabase database = data.data!;
            final userDao = database.userDao;
            return StreamBuilder<List<User>>(
              stream: userDao.findAllUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final List<User> userList = snapshot.data!;
                  return buildUserList(userList);
                } else {
                  return const Text("No data");
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
    return ListView(
      children: userList
          .map((item) => ListTile(
                title: Text(item.firstName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ))
          .toList(),
    );
    /*return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: const Text("Example"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        );
      },
    );*/
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
              onPressed: () {
                String firstname = _firstNameController.text;
                String lastname = _lastNameController.text;

                print("firstname : " + firstname + " lastname : " + lastname);
              },
            ),
          ),
        ],
      ),
    );
  }
}
