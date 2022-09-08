import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: const Text("Example"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            );
          }),
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
            children: const [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText:'Enter First Name',
                ),
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter Last Name'
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              child: const Text("Save"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
