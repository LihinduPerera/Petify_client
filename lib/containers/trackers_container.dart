import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petify/models/trackers_models.dart';
import 'package:provider/provider.dart';
import 'package:petify/providers/tracker_provider.dart';

class TrackersContainer extends StatefulWidget {
  final double height;
  final bool isAddable;
  final String petName;

  const TrackersContainer({
    super.key,
    required this.height,
    required this.isAddable,
    required this.petName,
  });

  @override
  State<TrackersContainer> createState() => _TrackersContainerState();
}

class _TrackersContainerState extends State<TrackersContainer> {
  TextEditingController medicationController = TextEditingController();
  TextEditingController vetVisitController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController mealController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    
    trackerProvider.fetchMedications();
    trackerProvider.fetchVetVisits(); 
    trackerProvider.fetchActivities();
    trackerProvider.fetchMeals();
  });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              const Icon(Icons.track_changes, color: Color.fromARGB(255, 81, 245, 130)),
              SizedBox(width: 10),
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
        SizedBox(height: 8),
        Container(
          height: widget.height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 255, 179, 179).withOpacity(0.6),
                  'Medications',
                  _buildMedicationLog(context),
                  medicationController,
                  'Add Medication',
                  () => _addMedication(context)),
              SizedBox(width: 10),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 213, 255, 179).withOpacity(0.6),
                  'Vet Visits',
                  _buildVetVisitLog(context),
                  vetVisitController,
                  'Add Vet Visit',
                  () => _addVetVisit(context)),
              SizedBox(width: 10),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 179, 227, 255).withOpacity(0.6),
                  'Activity Log',
                  _buildActivityLog(context),
                  activityController,
                  'Add Activity',
                  () => _addActivity(context)),
              SizedBox(width: 10),
              _buildCardsForTrackers(
                  const Color.fromARGB(255, 255, 254, 179).withOpacity(0.6),
                  'Meal Log',
                  _buildMealLog(context),
                  mealController,
                  'Add Meal',
                  () => _addMeal(context)),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                children: [
                  _buildSectionTitle(title),
                  logWidget,
                  SizedBox(height: 15),
                  widget.isAddable
                      ? Container(
                          width: 330,
                          child: _buildAddItemForm(
                              textEditingController, hintText, function),
                        )
                      : SizedBox(),
                ],
              ),
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
            color: Colors.black),
      ),
    );
  }

  Widget _buildMedicationLog(BuildContext context) {
    final medicationProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: [
        Column(
          children: medicationProvider.medications.isEmpty
              ? [Text('No medications logged yet.')]
              : medicationProvider.medications
                  .map((med) => ListTile(
                        title: Text(med.medicationLog, style: TextStyle(fontSize: 18),),
                        subtitle: Text(med.medicationDate.toString()),
                        dense: true,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteMedication(context, med.medicationId);
                          },
                        ),
                      ))
                  .toList(),
        ),
      ],
    );
  }

  void _addMedication(BuildContext context) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    if (medicationController.text.isNotEmpty) {
      trackerProvider.addMedication(
        MedicationsLogModel(
          medicationId: DateTime.now().toString(),
          medicationLog: widget.petName +" : "+ medicationController.text,
          medicationDate: Timestamp.now(),
        )
      );
      medicationController.clear();
    }
  }

  void _deleteMedication(BuildContext context, String medicationId) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteMedication(medicationId);
  }

  Widget _buildVetVisitLog(BuildContext context) {
    final vetVisitProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: vetVisitProvider.vetVisits.isEmpty
          ? [Text('No vet visits logged yet.')]
          : vetVisitProvider.vetVisits
              .map((visit) => ListTile(
                    title: Text(visit.vetVisitLog),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteVetVisit(context, visit.vetVisitId);
                      },
                    ),
                  ))
              .toList(),
    );
  }

  void _addVetVisit(BuildContext context) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    if (vetVisitController.text.isNotEmpty) {
      trackerProvider.addVetVisit(
        VetVisitLogModel(
          vetVisitId: DateTime.now().toString(),
          vetVisitLog: vetVisitController.text,
          vetVisitDate: Timestamp.now(),
        ),
      );
      vetVisitController.clear();
    }
  }

  void _deleteVetVisit(BuildContext context, String vetVisitId) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteVetVisit(vetVisitId);
  }

  Widget _buildActivityLog(BuildContext context) {
    final activityProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: activityProvider.activities.isEmpty
          ? [Text('No activities logged yet.')]
          : activityProvider.activities
              .map((activity) => ListTile(
                    title: Text(activity.activityLog),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteActivity(context, activity.activityId);
                      },
                    ),
                  ))
              .toList(),
    );
  }

  void _addActivity(BuildContext context) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    if (activityController.text.isNotEmpty) {
      trackerProvider.addActivity(
        ActivityLogModel(
          activityId: DateTime.now().toString(),
          activityLog: activityController.text,
          activityDate: Timestamp.now(),
          activityTime: Timestamp.now(),
        ),
      );
      activityController.clear();
    }
  }

  void _deleteActivity(BuildContext context, String activityId) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteActivitie(activityId);
  }

  Widget _buildMealLog(BuildContext context) {
    final mealProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: mealProvider.meals.isEmpty
          ? [Text('No meals logged yet.')]
          : mealProvider.meals
              .map((meal) => ListTile(
                    title: Text(meal.mealLog),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteMeal(context, meal.mealId);
                      },
                    ),
                  ))
              .toList(),
    );
  }

  void _addMeal(BuildContext context) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    if (mealController.text.isNotEmpty) {
      trackerProvider.addMeal(
        MealLogModel(
          mealId: DateTime.now().toString(),
          mealLog: mealController.text,
          mealTime: Timestamp.now(),
        ),
      );
      mealController.clear();
    }
  }

  void _deleteMeal(BuildContext context, String mealId) {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteMeal(mealId);
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
