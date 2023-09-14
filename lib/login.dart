import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              // controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Email",
              ),
            ),
            TextField(
              // controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Password",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
