import 'package:flutter/material.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/models/user_pets_model.dart';
import 'package:petify/providers/medical_provider.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:provider/provider.dart';

class MedicalContainer extends StatelessWidget {
  const MedicalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final userPetsProvider = Provider.of<UserPetsProvider>(context);
    final medicalProvider = Provider.of<MedicalProvider>(context);

    return userPetsProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : userPetsProvider.userPets.isEmpty
            ? const Center(child: Text("No pets found"))
            : SingleChildScrollView(
                child: Column(
                  children: userPetsProvider.userPets.map((pet) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              StreamBuilder<List<MedicalModel>>(
                                stream: medicalProvider.fetchMedicals(pet.petId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text("No medical records available"));
                                  }
                                  List<MedicalModel> medicals = snapshot.data!;

                                  return Column(
                                    children: medicals.map((medical) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            title: Text("Medication: ${medical.medication}"),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Date: ${medical.date.toLocal().toString().split(' ')[0]}"),
                                                Text("Status: ${medical.status}"),
                                              ],
                                            ),
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
                    );
                  }).toList(),
                ),
              );
  }
}
