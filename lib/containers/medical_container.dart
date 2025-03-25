import 'package:flutter/material.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/providers/medical_provider.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:provider/provider.dart';

class MedicalContainer extends StatelessWidget {
  final double defineHeight, defineWeight;
  
  const MedicalContainer({
    super.key, 
    required this.defineHeight, 
    required this.defineWeight,
  });

  @override
  Widget build(BuildContext context) {
    final userPetsProvider = Provider.of<UserPetsProvider>(context);

    return userPetsProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : userPetsProvider.userPets.isEmpty
            ? const Center(child: Text("No pets found"))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: userPetsProvider.userPets.map((pet) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: defineHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff92A3FD).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          // color: const Color(0xffc58BF2).withOpacity(0.4),
                          // elevation: 8,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    pet.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Consumer<MedicalProvider>(
                                    builder: (context, medicalProvider, child) {
                                      List<MedicalModel> medicals = medicalProvider.medicals
                                          .where((medical) => medical.pet == pet.petId)
                                          .toList();
                            
                                      if (medicalProvider.isLoading) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                            
                                      if (medicals.isEmpty) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                                            child: Text(
                                              "No medical \n records available",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                            
                                      return Column(
                                        children: medicals.map((medical) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: defineWeight,
                                                    child: ListTile(
                                                      title: Text("${medical.medication}",
                                                      style: TextStyle(fontSize: 15),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Date: ${medical.date.toLocal().toString().split(' ')[0]}"),
                                                          Row(
                                                            children: [
                                                              Text("Status: ",
                                                              ),
                                                              Text("${medical.status}",
                                                              style: TextStyle(
                                                                color: medical.status == "Completed" ? const Color.fromARGB(255, 73, 54, 244) : const Color.fromARGB(255, 0, 158, 5),
                                                              ),
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            thickness: 2,
                                                            color: const Color(0xffc58BF2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),                                          // decoration: BoxDecoration(
                                                    //   color: Color.fromARGB(255, 91, 113, 223).withOpacity(0.4),
                                                    //   borderRadius: BorderRadius.circular(20),
                                                    // ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
  }
}
