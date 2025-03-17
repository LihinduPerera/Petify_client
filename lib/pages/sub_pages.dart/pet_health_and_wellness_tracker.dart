// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:petify/containers/trackers_container.dart';
// import 'package:petify/containers/user_pets_container.dart';

// class PetHealthAndWellnessTrackerPage extends StatefulWidget {
//   const PetHealthAndWellnessTrackerPage({super.key});

//   @override
//   _PetHealthAndWellnessTrackerPageState createState() =>
//       _PetHealthAndWellnessTrackerPageState();
// }

// class _PetHealthAndWellnessTrackerPageState
//     extends State<PetHealthAndWellnessTrackerPage> {
//   String petType = "";
//   String petName = "";
//   double petWeight = 0;
//   int petAge = 0;

//   void _updatePetDetails(
//       String newPetName, double newPetWeight, int newAge, String newPetType) {
//     setState(() {
//       petName = newPetName;
//       petWeight = newPetWeight;
//       petAge = newAge;
//       petType = newPetType;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pet Health & Wellness'),
//         backgroundColor: Color(0xFFeeedf2),
//       ),
//       backgroundColor: Color(0xFFeeedf2),
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.all(8.0),
//           children: [
//             SizedBox(
//               height: 5,
//             ),
//             UserPetsContainerForTracker(
//                 onPetSelected: _updatePetDetails), // Pass callback
//             SizedBox(
//               height: 10,
//             ),
//             petName == ""
//                 ? Column(
//                   children: [
//                     SizedBox(height: 40,),
//                     Text("Select A Pet \n To Manage Logs", textAlign: TextAlign.center , style: TextStyle(
//                       color: Colors.deepPurple,
//                       fontSize: 27,
//                       fontWeight: FontWeight.bold
//                     ),),
//                     SizedBox(height: 5,),
//                     Container(
//                       height: 180,
//                       child: Lottie.asset(
//                         'assets/animations/look_up_lottie.json',
//                         fit: BoxFit.contain
//                       ),
//                     ),
//                     SizedBox(height: 5,),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Text("Easily track your pet's health by logging past and future medications, vet visits, activities, and meals.", textAlign: TextAlign.center , style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold
//                       ),),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text("If no date and time are selected, the current ones will be used. Add, view, and delete entries to stay on top of your pet's care." , textAlign: TextAlign.center , style: TextStyle(
//                           color: const Color.fromARGB(255, 58, 183, 85),
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold
//                         ),),
//                     )
//                   ],
//                 )
//                 : Column(
//                     children: [
//                       _buildPetInfoCard(),
//                       SizedBox(height: 5),
//                       Divider(),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TrackersContainer(
//                         height: 500,
//                         isAddable: true,
//                         petName: petName,
//                       )
//                     ],
//                   )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPetInfoCard() {
//     String modelPic;
//     if (petType == "Dog") {
//       modelPic = "assets/images/user_pet_model_default_dog.png";
//     } else if (petType == "Cat") {
//       modelPic = "assets/images/user_pet_model_default_cat.png";
//     } else {
//       modelPic = "assets/images/user_pet_model_default.png";
//     }
//     return Card(
//       color: const Color(0xffc58BF2).withOpacity(0.4),
//       elevation: 8,
//       shadowColor: Colors.blueGrey.withOpacity(0.4),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(16),
//         title: Text('$petName',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         subtitle: Text('Age: $petAge years\nWeight: $petWeight kg'),
//         leading: CircleAvatar(
//           radius: 30,
//           backgroundImage: AssetImage(modelPic),
//         ),
//       ),
//     );
//   }
// }
