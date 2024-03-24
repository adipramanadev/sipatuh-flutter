import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pelanggaran/nobox/cache.dart';
// import 'package:pelanggaran/nobox/nobox.dart';
import 'package:pelanggaran/nobox/route.dart';
import 'package:pelanggaran/nobox/sendmessage.dart';

import 'cache.dart';
import 'loading.dart';
import 'nobox.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showLoading() {
      Get.dialog(LoadingDialog(), barrierDismissible: false);
    }

    void hideLoading() {
      Get.back();
    }

    TextEditingController _emailController =
        TextEditingController(text: "demonobox@gmail.com");
    TextEditingController _passwordController =
        TextEditingController(text: "opklnm123");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login NoBox'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  final nobox = Nobox("");
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  showLoading();
                  final tokenResponse =
                      await nobox.generateToken(email, password);
                  // ignore: avoid_print
                  hideLoading();
                  if (!tokenResponse.isError) {
                    // Successful login
                    // Navigator.pushReplacementNamed(context, '/home');
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: Text(tokenResponse.data),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                await CacheManagerService()
                                    .saveVariable("token", tokenResponse.data);
                                // ignore: use_build_context_synchronously
                              Get.to(Sendmessage());
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Invalid login
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text(tokenResponse.error.toString()),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  // Validate login credentials here

                  // Example validation:
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3a57e8)),
                    fixedSize: MaterialStatePropertyAll(Size.copy(
                        Size(MediaQuery.of(context).size.width, 50)))),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

