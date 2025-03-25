import 'package:flutter/material.dart';
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
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: const Text(
                            "Medicals",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.medical_services , color: const Color.fromARGB(255, 221, 100, 91),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    MedicalContainer(
                      defineHeight: 500,
                      defineWeight: 250,
                    )
                  ],
                )
              ],
            ),
          ),
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
        subtitle: Row(
          children: [
            Text('Age: $age years\nGender: $gender'),
            SizedBox(
              width: 15,
            ),
            Text('Species: $species\nBreed: $breed'),
          ],
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(modelPic),
        ),
      ),
    );
  }
}
