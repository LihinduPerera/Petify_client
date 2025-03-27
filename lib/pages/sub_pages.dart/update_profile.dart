import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address;
    _phoneController.text = user.phone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      appBar: AppBar(
        title: Text("Update Profile"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
            child: Column(
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/animations/CuttiePack_Note.json'
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Name cannot be empty." : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Email cannot be empty." : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  maxLines: 3,
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    hintText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Address cannot be empty." : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    hintText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Phone cannot be empty." : null,
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String newName = _nameController.text;
                        String newAddress = _addressController.text;
                        String newPhone = _phoneController.text;

                        try {
                          String result = await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).updateUser(newName, newAddress, newPhone);

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(result)));

                          if (result == "User updated successfully!") {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error updating profile: $e"),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: const Color.fromARGB(255, 246, 180, 255).withOpacity(0.4),
                      foregroundColor: Colors.black
                    ),
                    child: Text(
                      "Update Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
