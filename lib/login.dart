import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_ist/home.dart';
import 'package:todo_ist/register.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    // we can use this instance to store the data in our shared preference
    prefs = await SharedPreferences.getInstance();
  }

  void login() async {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      var body = {
        "email": emailController.text,
        "password": passController.text
      };

      var response = await http.post(
        Uri.parse('http://192.168.43.54:3000/login'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['success']);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        // store the token in the shared preference instance
        prefs.setString('token', myToken);

// pass the myToken variable to the home page when navigates
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      token: myToken,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          child: Column(children: [
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
              onPressed: () => {login()},
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => Register()))
              },
              child: Text('Go to Register'),
            ),
          ]),
        ),
      ),
    );
  }
}
