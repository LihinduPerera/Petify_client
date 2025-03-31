import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Lottie.asset('assets/animations/hellow_world.json',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              shadowColor: Colors.black,
                              backgroundColor: Color.fromARGB(255, 229, 255, 254).withOpacity(0.6)),
                            onPressed: () async {
                              AuthService authService = new AuthService();
                              await authService
                                  .loginUsingGoogleAuth()
                                  .then((value) async {
                                if (value == "Login Successful") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Login Successful")),
                                  );

                                  await Provider.of<UserProvider>(context,
                                          listen: false)
                                      .loadUserData();

                                  Navigator.restorablePushNamedAndRemoveUntil(
                                    context,
                                    "/",
                                    (route) => false,
                                  );
                                } else {
                                  print(value);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 239, 83, 80),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                                height: 30,
                                child: Image.asset("assets/images/google_login.png")),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                                shadowColor: Colors.black,
                                backgroundColor:Color.fromARGB(255, 255, 229, 231).withOpacity(0.6)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("This Feature is not available yet !"),
                                backgroundColor: const Color.fromARGB(255, 54, 82, 244),),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/images/apple_logo.png")),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Apple ID",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "LogIn",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Email cannot be empty." : null,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Password should have atleast 8 characters."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: const Text("Forget Password"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Enter your email"),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    label: Text("Email"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_emailController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Email cannot be empty"),
                                      ),
                                    );
                                    return;
                                  }
                                  await AuthService()
                                      .resetPassword(_emailController.text)
                                      .then((value) {
                                    if (value == "Mail Sent") {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Password reset link sent to your email",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            239,
                                            83,
                                            80,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: const Text("Submit"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Forget Password",
                      style:
                          TextStyle(color: Color.fromARGB(255, 114, 133, 228)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      AuthService()
                          .loginWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      )
                          .then((value) async {
                        if (value == "Login Successful") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Successful")),
                          );

                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .loadUserData();

                          Navigator.restorablePushNamedAndRemoveUntil(
                            context,
                            "/",
                            (route) => false,
                          );
                        } else {
                          print(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                239,
                                83,
                                80,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 219, 197, 74).withOpacity(0.6),
                      foregroundColor: Colors.black),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Sign Up",
                      style:
                          TextStyle(color: Color.fromARGB(255, 114, 133, 228)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
