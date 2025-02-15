import 'package:flutter/material.dart';

class TrackersContainer extends StatefulWidget {
  final double height;
  final bool isAddable;
  const TrackersContainer({super.key, required this.height , required this.isAddable});

  @override
  State<TrackersContainer> createState() => _TrackersContainerState();
}

class _TrackersContainerState extends State<TrackersContainer> {
  List<String> medications = [];
  List<String> vetVisits = [];
  List<String> activityLogs = [];
  List<String> mealLogs = [];

  TextEditingController medicationController = TextEditingController();
  TextEditingController vetVisitController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController mealController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Icon(Icons.track_changes,color: Color.fromARGB(255, 81, 245, 130)),
              SizedBox(width: 10,),
              const Text(
                "Logs and Trackers",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8,),
        Container(
          height: widget.height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 255, 179, 179).withOpacity(0.6),
                  'Medications',
                  _buildMedicationLog(),
                  medicationController,
                  'Add Medication',
                  _addMedication),
              SizedBox(
                width: 10,
              ),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 213, 255, 179).withOpacity(0.6),
                  'Vet Visits',
                  _buildVetVisitLog(),
                  vetVisitController,
                  'Add Vet Visit',
                  _addVetVisit),
              SizedBox(
                width: 10,
              ),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 179, 227, 255).withOpacity(0.6),
                  'Activity Log',
                  _buildActivityLog(),
                  activityController,
                  'Add Activity',
                  _addActivity),
              SizedBox(
                width: 10,
              ),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 255, 254, 179).withOpacity(0.6),
                  'Meal Log',
                  _buildMealLog(),
                  mealController,
                  'Add Meal',
                  _addMeal),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardsForTrackers(
      Color color,
      String title,
      Widget logWidget,
      TextEditingController textEditingController,
      String hintText,
      VoidCallback function) {
    return Container(
      width: 340,
      child: Card(
        color: color,
        // elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildSectionTitle(title),
              _buildMedicationLog(),
              SizedBox(height: 15),
              widget.isAddable
              ?Container(
                width: 330,
                child: _buildAddItemForm(
                    textEditingController, hintText, function),
              )
              :SizedBox()
            ],
          ),
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
            // color: Color(0xFF3b3b3b)
            color: Colors.black),
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
