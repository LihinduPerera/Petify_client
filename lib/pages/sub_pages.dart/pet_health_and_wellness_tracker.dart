import 'package:flutter/material.dart';
import 'package:petify/containers/trackers_container.dart';
import 'package:petify/containers/user_pets_container.dart';

class PetHealthAndWellnessTrackerPage extends StatefulWidget {
  const PetHealthAndWellnessTrackerPage({super.key});

  @override
  _PetHealthAndWellnessTrackerPageState createState() =>
      _PetHealthAndWellnessTrackerPageState();
}

class _PetHealthAndWellnessTrackerPageState
    extends State<PetHealthAndWellnessTrackerPage> {
  String petType = "nunSelected";
  String petName = 'Select the pet';
  double petWeight = 0;
  int petAge = 0;
  String petId= "";

  void _updatePetDetails(
      String newPetName, double newPetWeight, int newAge, String newPetType, String newPetId) {
    setState(() {
      petName = newPetName;
      petWeight = newPetWeight;
      petAge = newAge;
      petType = newPetType;
      petId = newPetId;
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
            UserPetsContainerForTracker(
                onPetSelected: _updatePetDetails), // Pass callback
            SizedBox(
              height: 10,
            ),
            _buildPetInfoCard(),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 20,),
            TrackersContainer(height: 500, isAddable: true, petName: petName, petId: petName,)
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoCard() {
    String modelPic;
    if (petType == "Dog") {
      modelPic = "assets/images/user_pet_model_default_dog.png";
    } else if (petType == "Cat") {
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
        title: Text('$petName',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        subtitle: Text('Age: $petAge years\nWeight: $petWeight kg'),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(modelPic),
        ),
      ),
    );
  }
}
