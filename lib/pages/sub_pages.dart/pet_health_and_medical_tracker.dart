import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/containers/medical_container.dart';
import 'package:petify/containers/user_pets_container.dart';

class PetHealthAndMedicalTrackerPage extends StatefulWidget {
  const PetHealthAndMedicalTrackerPage({super.key});

  @override
  _PetHealthAndMedicalTrackerPageState createState() =>
      _PetHealthAndMedicalTrackerPageState();
}

class _PetHealthAndMedicalTrackerPageState
    extends State<PetHealthAndMedicalTrackerPage> {
  String petId = "";
  String name = "";
  String breed = "";
  int age = 0;
  String gender = "";
  String species = "";

  void _updatePetDetails(String newPetId, String newName, String newBreed,
      int newAge, String newGender, String newSpecies) {
    setState(() {
      petId = newPetId;
      name = newName;
      breed = newBreed;
      age = newAge;
      gender = newGender;
      species = newSpecies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Health & Wellness'),
        backgroundColor: Color(0xFFeeedf2),
      ),
      backgroundColor: Color(0xFFeeedf2),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            SizedBox(
              height: 5,
            ),
            UserPetsContainerForTracker(onPetSelected: _updatePetDetails),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                _buildPetInfoCard(),
                SizedBox(height: 5),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                MedicalContainer(
                  defineHeight: 400,
                  defineWeight: 150,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoCard() {
    String modelPic;
    if (species == "Dog") {
      modelPic = "assets/images/user_pet_model_default_dog.png";
    } else if (species == "Cat") {
      modelPic = "assets/images/user_pet_model_default_cat.png";
    } else {
      modelPic = "assets/images/user_pet_model_default.png";
    }
    return Card(
      color: const Color(0xffc58BF2).withOpacity(0.4),
      elevation: 8,
      shadowColor: Colors.blueGrey.withOpacity(0.4),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(name == "" ? "Select A Pet to View" : "$name",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        subtitle: Text('Age: $age years\ngender: $gender'),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(modelPic),
        ),
      ),
    );
  }
}
