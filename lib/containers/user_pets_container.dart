import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/user_pets_model.dart';

class UserPetsContainer extends StatefulWidget {
  const UserPetsContainer({super.key});

  @override
  State<UserPetsContainer> createState() => _UserPetsContainerState();
}

class _UserPetsContainerState extends State<UserPetsContainer> {
  List<UserPetsModel> userPets = [];

  void _getUserPets() {
    DbService().getUserPets().listen((pets) {
      setState(() {
        userPets = pets;
      });
    });
  }

  void _showAddOrUpdatePetDialog({UserPetsModel? pet}) {
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController petWeightController = TextEditingController();
    String petType = "Dog";

    if (pet != null) {
      petNameController.text = pet.petName;
      petWeightController.text = pet.petWeight.toString();
      petType = pet.petType;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(pet == null ? 'Add a New Pet' : 'Update Pet Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: petNameController,
                    decoration: const InputDecoration(labelText: 'Pet Name'),
                  ),
                  TextField(
                    controller: petWeightController,
                    decoration: const InputDecoration(labelText: 'Pet Weight'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  ),
                  Row(
                    children: [
                      Text("Pet Type :", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 18),
                      DropdownButton<String>(
                        value: petType,
                        onChanged: (String? newValue) {
                          setState(() {
                            petType = newValue!;
                          });
                        },
                        items: <String>['Dog', 'Cat']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                if (pet != null)
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this pet?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  DbService().deletePet(pet.petId);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Delete Pet'),
                  ),
                TextButton(
                  onPressed: () {
                    String petName = petNameController.text.trim();
                    double petWeight =
                        double.tryParse(petWeightController.text.trim()) ?? 0;

                    if (petName.isNotEmpty) {
                      final updatedPet = UserPetsModel(
                        petId: pet?.petId ?? DateTime.now().toString(),
                        petName: petName,
                        petType: petType,
                        petWeight: petWeight,
                      );

                      if (pet == null) {
                        DbService().addPet(updatedPet);
                      } else {
                        DbService().updatePet(updatedPet);
                      }

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  child: Text(pet == null ? 'Add Pet' : 'Update Pet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserPets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const Text(
            "Your Pets",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 100,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemCount: userPets.length + 1,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    _showAddOrUpdatePetDialog();
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffc58BF2).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 30, color: Colors.blue),
                        const Text("Add Pets"),
                      ],
                    ),
                  ),
                );
              } else {
                int petIndex = index - 1;
                String modelPic;
                if (userPets[petIndex].petType == "Dog") {
                  modelPic = "assets/images/user_pet_model_default_dog.png";
                } else if (userPets[petIndex].petType == "Cat") {
                  modelPic = "assets/images/user_pet_model_default_cat.png";
                } else {
                  modelPic = "assets/images/user_pet_model_default.png";
                }

                return GestureDetector(
                  onTap: () {
                    _showAddOrUpdatePetDialog(pet: userPets[petIndex]);
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff92A3FD).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(modelPic),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          userPets[petIndex].petName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
