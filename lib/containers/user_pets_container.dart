import 'package:flutter/material.dart';
import 'package:petify/models/user_pets_model.dart';
import 'package:provider/provider.dart';
import 'package:petify/providers/user_pets_provider.dart';

class UserPetsContainer extends StatefulWidget {
  const UserPetsContainer({super.key});

  @override
  State<UserPetsContainer> createState() => _UserPetsContainerState();
}

class _UserPetsContainerState extends State<UserPetsContainer> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserPetsProvider>(context, listen: false).fetchUserPets();
  }

  void _showAddOrUpdatePetDialog({UserPetsModel? pet}) {
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController petWeightController = TextEditingController();
    String petType = "Dog";
    int petAge = 2;

    if (pet != null) {
      petNameController.text = pet.petName;
      petWeightController.text = pet.petWeight.toString();
      petType = pet.petType;
      petAge = pet.petAge;
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
                      Text("Pet Type:", style: TextStyle(fontSize: 18)),
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
                  Row(
                    children: [
                      Text("Pet Age:", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: DropdownButton<int>(
                            value: petAge,
                            onChanged: (int? newValue) {
                              setState(() {
                                petAge = newValue!;
                              });
                            },
                            items: List.generate(30, (index) => index + 1)
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            elevation: 10,
                            iconSize: 30,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ],
                  )
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
                                  Provider.of<UserPetsProvider>(context,
                                          listen: false)
                                      .deletePet(pet.petId);
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
                        petAge: petAge,
                        petType: petType,
                        petWeight: petWeight,
                      );

                      if (pet == null) {
                        Provider.of<UserPetsProvider>(context, listen: false)
                            .addPet(updatedPet);
                      } else {
                        Provider.of<UserPetsProvider>(context, listen: false)
                            .updatePet(updatedPet);
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
  Widget build(BuildContext context) {
    return Consumer<UserPetsProvider>(
      builder: (context, userPetsProvider, child) {
        if (userPetsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
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
                  itemCount: userPetsProvider.userPets.isEmpty
                      ? 1
                      : userPetsProvider.userPets.length + 1,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    if (userPetsProvider.userPets.isEmpty || index == 0) {
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
                            children: const [
                              Icon(Icons.add, size: 30, color: Colors.blue),
                              Text("Add Pets"),
                            ],
                          ),
                        ),
                      );
                    } else {
                      int petIndex = index - 1;
                      String modelPic;
                      if (userPetsProvider.userPets[petIndex].petType ==
                          "Dog") {
                        modelPic =
                            "assets/images/user_pet_model_default_dog.png";
                      } else if (userPetsProvider.userPets[petIndex].petType ==
                          "Cat") {
                        modelPic =
                            "assets/images/user_pet_model_default_cat.png";
                      } else {
                        modelPic = "assets/images/user_pet_model_default.png";
                      }

                      return GestureDetector(
                        onTap: () {
                          _showAddOrUpdatePetDialog(
                              pet: userPetsProvider.userPets[petIndex]);
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  userPetsProvider.userPets[petIndex].petName,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
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
      },
    );
  }
}

class UserPetsContainerForTracker extends StatefulWidget {
  final Function(String petName, double petWeight, int petAge, String petType)
      onPetSelected;

  const UserPetsContainerForTracker({super.key, required this.onPetSelected});

  @override
  State<UserPetsContainerForTracker> createState() =>
      _UserPetsContainerForTrackerState();
}

class _UserPetsContainerForTrackerState
    extends State<UserPetsContainerForTracker> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserPetsProvider>(context, listen: false).fetchUserPets();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPetsProvider>(
      builder: (context, userPetsProvider, child) {
        if (userPetsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
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
                  itemCount: userPetsProvider.userPets.isEmpty
                      ? 1
                      : userPetsProvider.userPets.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    if (userPetsProvider.userPets.isEmpty) {
                      return Center(child: Text("No pets available"));
                    } else {
                      int petIndex = index;
                      String modelPic;
                      if (userPetsProvider.userPets[petIndex].petType ==
                          "Dog") {
                        modelPic =
                            "assets/images/user_pet_model_default_dog.png";
                      } else if (userPetsProvider.userPets[petIndex].petType ==
                          "Cat") {
                        modelPic =
                            "assets/images/user_pet_model_default_cat.png";
                      } else {
                        modelPic = "assets/images/user_pet_model_default.png";
                      }

                      return GestureDetector(
                        onTap: () {
                          widget.onPetSelected(
                              userPetsProvider.userPets[petIndex].petName,
                              userPetsProvider.userPets[petIndex].petWeight,
                              userPetsProvider.userPets[petIndex].petAge,
                              userPetsProvider.userPets[petIndex].petType);
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
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(modelPic),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  userPetsProvider.userPets[petIndex].petName,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
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
      },
    );
  }
}
