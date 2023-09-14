import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_ist/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void registerUser() async {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      // init the body
      var body = {
        "email": emailController.text,
        "password": passController.text,
      };
      var response = await http.post(
        // set the URL
        Uri.parse('http://192.168.0.224:3000/register'),
        // send the data with the body of the request
        body: jsonEncode(body),
        // set the headers
        headers: {"Content-Type": "application/json"},
      );
      // decode the response to use it later
      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['success']);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Email",
              ),
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: () => {registerUser()},
              child: Text('register'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()))
              },
              child: Text('Go to Login'),
            ),
          ],
        )),
      ),
    );
  }
}
