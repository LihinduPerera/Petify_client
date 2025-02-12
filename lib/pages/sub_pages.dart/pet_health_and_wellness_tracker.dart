import 'package:flutter/material.dart';
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

  List<String> medications = [];
  List<String> vetVisits = [];
  List<String> activityLogs = [];
  List<String> mealLogs = [];

  TextEditingController medicationController = TextEditingController();
  TextEditingController vetVisitController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController mealController = TextEditingController();

  void _updatePetDetails(
      String newPetName, double newPetWeight, int newAge, String newPetType) {
    setState(() {
      petName = newPetName;
      petWeight = newPetWeight;
      petAge = newAge;
      petType = newPetType;
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
            SizedBox(height: 15),
            Divider(),
            _buildSectionTitle('Medications'),
            _buildMedicationLog(),
            SizedBox(height: 15),
            _buildAddItemForm(
                medicationController, 'Add Medication', _addMedication),
            SizedBox(height: 15),
            Divider(),
            _buildSectionTitle('Vet Visits'),
            _buildVetVisitLog(),
            SizedBox(height: 15),
            _buildAddItemForm(
                vetVisitController, 'Add Vet Visit', _addVetVisit),
            SizedBox(height: 15),
            Divider(),
            _buildSectionTitle('Activity Log'),
            _buildActivityLog(),
            SizedBox(height: 15),
            _buildAddItemForm(activityController, 'Add Activity', _addActivity),
            SizedBox(height: 15),
            Divider(),
            _buildSectionTitle('Meal Log'),
            _buildMealLog(),
            SizedBox(height: 15),
            _buildAddItemForm(mealController, 'Add Meal', _addMeal),
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
      elevation: 18,
      // shadowColor: Colors.transparent,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3b3b3b)),
      ),
    );
  }

  Widget _buildMedicationLog() {
    return Column(
      children: medications.isEmpty
          ? [Text('No medications logged yet.')]
          : medications.map((med) => ListTile(title: Text(med))).toList(),
    );
  }

  void _addMedication() {
    if (medicationController.text.isNotEmpty) {
      setState(() {
        medications.add(medicationController.text);
        medicationController.clear();
      });
    }
  }

  Widget _buildVetVisitLog() {
    return Column(
      children: vetVisits.isEmpty
          ? [Text('No vet visits logged yet.')]
          : vetVisits.map((visit) => ListTile(title: Text(visit))).toList(),
    );
  }

  void _addVetVisit() {
    if (vetVisitController.text.isNotEmpty) {
      setState(() {
        vetVisits.add(vetVisitController.text);
        vetVisitController.clear();
      });
    }
  }

  Widget _buildActivityLog() {
    return Column(
      children: activityLogs.isEmpty
          ? [Text('No activities logged yet.')]
          : activityLogs
              .map((activity) => ListTile(title: Text(activity)))
              .toList(),
    );
  }

  void _addActivity() {
    if (activityController.text.isNotEmpty) {
      setState(() {
        activityLogs.add(activityController.text);
        activityController.clear();
      });
    }
  }

  Widget _buildMealLog() {
    return Column(
      children: mealLogs.isEmpty
          ? [Text('No meals logged yet.')]
          : mealLogs.map((meal) => ListTile(title: Text(meal))).toList(),
    );
  }

  void _addMeal() {
    if (mealController.text.isNotEmpty) {
      setState(() {
        mealLogs.add(mealController.text);
        mealController.clear();
      });
    }
  }

  Widget _buildAddItemForm(
      TextEditingController controller, String hintText, Function onSubmit) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText, border: OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.blue),
          onPressed: () => onSubmit(),
        ),
      ],
    );
  }
}
