import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Lottie.asset('assets/animations/hellow_world.json',
                          width: MediaQuery.of(context).size.width / 1.25,
                          fit: BoxFit.fitWidth),
                    ),
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Name cannot be empty." : null,
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Name"),
                          ),
                          maxLength: 15,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Email cannot be empty." : null,
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Email"),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) => value!.length < 8
                              ? "Password should have at least 8 characters."
                              : null,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Password"),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) =>
                              value != _passwordController.text
                                  ? "Passwords do not match!"
                                  : null, // Confirm password validation
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Confirm Password"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          AuthService()
                              .createAccountWithEmail(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _confirmPasswordController
                                      .text) // Pass confirmPassword
                              .then((value) {
                            if (value == "Account Created") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Account Created")));

                              Provider.of<UserProvider>(context, listen: false)
                                  .loadUserData();

                              Navigator.restorablePushNamedAndRemoveUntil(
                                  context, "/", (route) => false);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red.shade400,
                              ));
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 219, 197, 74)
                              .withOpacity(0.6),
                          foregroundColor: Colors.black),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
