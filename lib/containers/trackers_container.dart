import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trackerProvider =
          Provider.of<TrackerProvider>(context, listen: false);

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
              const Icon(Icons.track_changes,
                  color: Color.fromARGB(255, 81, 245, 130)),
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
      width: 320,
      child: Card(
        color: color,
        child: ListView(
          children: [
            Column(
              children: [
                _buildSectionTitle(title),
                logWidget,
                SizedBox(height: 15),
                widget.isAddable
                    ? Container(
                        width: 320,
                        child: _buildAddItemForm(
                            textEditingController, hintText, function),
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime); //(e.g., Feb 17, 2025)
  }

  String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime); //(e.g., 10:30 AM)
  }

  String _getLogStatus(DateTime logDateTime) {
    DateTime now = DateTime.now();
    if (logDateTime.isBefore(now)) {
      return 'Past';
    } else {
      return 'Upcoming';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        ) ??
        TimeOfDay.now();
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  DateTime _getSelectedDateTime() {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }
    return DateTime.now();
  }

  Widget _buildMedicationLog(BuildContext context) {
    final medicationProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: medicationProvider.medications.isEmpty
          ? [Text('No medications logged yet.')]
          : medicationProvider.medications
              .map((med) => ListTile(
                    title:
                        Text(med.medicationLog,style: TextStyle(fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text(formatDateTime(med.medicationDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        Text(formatTime(med.medicationDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        widget.isAddable
                        ?Text(
                          _getLogStatus(med.medicationDate),
                          style: TextStyle(fontSize: 11, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                        :Text(
                          _getLogStatus(med.medicationDate),
                          style: TextStyle(fontSize: 15, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    dense: true,
                    trailing: widget.isAddable
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteMedication(context, med.medicationId);
                            },
                          )
                        : SizedBox(),
                  ))
              .toList(),
    );
  }

  void _addMedication(BuildContext context) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    if (medicationController.text.isNotEmpty) {
      DateTime selectedDateTime = _getSelectedDateTime();
      trackerProvider.addMedication(MedicationsLogModel(
        medicationId: DateTime.now().toString(),
        medicationLog: widget.petName + " : " + medicationController.text,
        medicationDate: selectedDateTime,
      ));
      medicationController.clear();
      selectedDate = null;
      selectedTime = null;
    }
  }

  void _deleteMedication(BuildContext context, String medicationId) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteMedication(medicationId);
  }

  Widget _buildVetVisitLog(BuildContext context) {
    final vetVisitProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: vetVisitProvider.vetVisits.isEmpty
          ? [Text('No vet visits logged yet.')]
          : vetVisitProvider.vetVisits
              .map((visit) => ListTile(
                    title: Text(visit.vetVisitLog,style: TextStyle(fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text(formatDateTime(visit.vetVisitDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        Text(formatTime(visit.vetVisitDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        widget.isAddable
                        ?Text(
                          _getLogStatus(visit.vetVisitDate),
                          style: TextStyle(fontSize: 11, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                        :Text(
                          _getLogStatus(visit.vetVisitDate),
                          style: TextStyle(fontSize: 15, color: Colors.red , fontWeight: FontWeight.bold),
                        ),
                      ]
                    ),
                    trailing: widget.isAddable
                    ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteVetVisit(context, visit.vetVisitId);
                      },
                    )
                    :SizedBox(),
                    dense: true
                  ))
              .toList(),
    );
  }

  void _addVetVisit(BuildContext context) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    if (vetVisitController.text.isNotEmpty) {
      DateTime selectedDateTime = _getSelectedDateTime();
      trackerProvider.addVetVisit(
        VetVisitLogModel(
          vetVisitId: DateTime.now().toString(),
          vetVisitLog: widget.petName + " : " + vetVisitController.text,
          vetVisitDate: selectedDateTime,
        ),
      );
      vetVisitController.clear();
      selectedDate = null;
      selectedTime = null;
    }
  }

  void _deleteVetVisit(BuildContext context, String vetVisitId) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteVetVisit(vetVisitId);
  }

  Widget _buildActivityLog(BuildContext context) {
    final activityProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: activityProvider.activities.isEmpty
          ? [Text('No activities logged yet.')]
          : activityProvider.activities
              .map((activity) => ListTile(
                    title: Text(activity.activityLog,style: TextStyle(fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text(formatDateTime(activity.activityDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        Text(formatTime(activity.activityDate),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        widget.isAddable
                        ?Text(
                          _getLogStatus(activity.activityDate),
                          style: TextStyle(fontSize: 11, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                        :Text(
                          _getLogStatus(activity.activityDate),
                          style: TextStyle(fontSize: 15, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    trailing: widget.isAddable
                    ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteActivity(context, activity.activityId);
                      },
                    )
                    : SizedBox(), dense: true,
                  ))
              .toList(),
    );
  }

  void _addActivity(BuildContext context) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    if (activityController.text.isNotEmpty) {
      DateTime selectedDateTime = _getSelectedDateTime();
      trackerProvider.addActivity(
        ActivityLogModel(
          activityId: DateTime.now().toString(),
          activityLog: activityController.text,
          activityDate: selectedDateTime,
        ),
      );
      activityController.clear();
      selectedDate = null;
      selectedTime = null;
    }
  }

  void _deleteActivity(BuildContext context, String activityId) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteActivitie(activityId);
  }

  Widget _buildMealLog(BuildContext context) {
    final mealProvider = Provider.of<TrackerProvider>(context);
    return Column(
      children: mealProvider.meals.isEmpty
          ? [Text('No meals logged yet.')]
          : mealProvider.meals
              .map((meal) => ListTile(
                    title: Text(meal.mealLog,style: TextStyle(fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text(formatDateTime(meal.mealTime),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        Text(formatTime(meal.mealTime),
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        widget.isAddable
                        ?Text(
                          _getLogStatus(meal.mealTime),
                          style: TextStyle(fontSize: 11, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                        :Text(
                          _getLogStatus(meal.mealTime),
                          style: TextStyle(fontSize: 15, color: Colors.red , fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    trailing: widget.isAddable
                    ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteMeal(context, meal.mealId);
                      },
                    )
                    : SizedBox(), dense: true,
                  ))
              .toList(),
    );
  }

  void _addMeal(BuildContext context) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    if (mealController.text.isNotEmpty) {
      DateTime selectedDateTime = _getSelectedDateTime();
      trackerProvider.addMeal(
        MealLogModel(
          mealId: DateTime.now().toString(),
          mealLog: widget.petName + " : " + mealController.text,
          mealTime: selectedDateTime,
        ),
      );
      mealController.clear();
      selectedDate = null;
      selectedTime = null;
    }
  }

  void _deleteMeal(BuildContext context, String mealId) {
    final trackerProvider =
        Provider.of<TrackerProvider>(context, listen: false);
    trackerProvider.deleteMeal(mealId);
  }

  Widget _buildAddItemForm(
      TextEditingController controller, String hintText, Function onSubmit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: hintText, border: OutlineInputBorder()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () async {
              await _selectDate(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time, color: Colors.blue),
            onPressed: () async {
              await _selectTime(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.blue),
            onPressed: () => onSubmit(),
          ),
        ],
      ),
    );
  }
}
