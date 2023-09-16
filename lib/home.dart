import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final token;

  const Home({super.key, this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController Todo_Title_Controller = TextEditingController();
  TextEditingController Todo_Decs_Controller = TextEditingController();
  List? items; // Initialize as null

  late String userID;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userID = jwtDecodedToken['_id'];
    getTodoList(userID);
  }

  void getTodoList(userID) async {
    var Body = {
      "userId": userID,
    };

    var response = await http.post(
      Uri.parse("http://192.168.43.54:3000/getUserTodoList"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(Body),
    );

    var jsonResponse = jsonDecode(response.body);
    // print('hakam ');
    setState(() {
      items = jsonResponse['success'];
    });
  }

  void Add_Todo() async {
    if (Todo_Title_Controller.text.isNotEmpty &&
        Todo_Decs_Controller.text.isNotEmpty) {
      var TodoBody = {
        "userId": userID,
        "title": Todo_Title_Controller.text,
        "desc": Todo_Decs_Controller.text
      };

      var response = await http.post(
        Uri.parse("http://192.168.43.54:3000/createToDo"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(TodoBody),
      );

      // if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Todo_Title_Controller.clear();
        Todo_Decs_Controller.clear();
        Navigator.pop(context);
        getTodoList(userID);
      }
    }
  }

  void deleteItem(userID) async {
    // print(id);
    var body = {
      "id": userID,
    };

    var response = await http.post(
      Uri.parse("http://192.168.43.54:3000/deleteTodo"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    var jsonRespone = jsonDecode(response.body);
    if (jsonRespone['status']) {
      // getTodoList(userID);
      setState(() {
        items!.removeWhere((item) => item['_id'] == userID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // decoration: BoxDecoration(color: Colors.cyan),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "My ToDo List",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              )),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: items == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: items!.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(items![index]['_id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                // Handle dismiss action here (e.g., delete item)
                                // setState(() {
                                //   items!.removeAt(index);
                                // });
                                deleteItem('${items![index]['_id']}');
                                // print('${items![index]['_id']}');
                              },
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.task),
                                  title: Text(items![index]['title']),
                                  subtitle: Text(items![index]['description']),
                                  trailing: Icon(Icons.arrow_back),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {TodoDialog(context)},
        child: Icon(Icons.add),
        tooltip: 'Add ToDo',
      ),
    );
  }

  Future<void> TodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: Todo_Title_Controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: "Title",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: Todo_Decs_Controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: "Description",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () => {Add_Todo()},
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
