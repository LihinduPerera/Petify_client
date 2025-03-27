import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  "Your Pets 🐕",
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 23),
                  itemCount: userPetsProvider.userPets.isEmpty
                      ? 1
                      : userPetsProvider.userPets.length + 1,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
                      if (userPetsProvider.userPets[petIndex].species ==
                          "Dog") {
                        modelPic =
                            "assets/images/user_pet_model_default_dog.png";
                      } else if (userPetsProvider.userPets[petIndex].species ==
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
                            color: const Color(0xff92A3FD).withOpacity(0.4),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  userPetsProvider.userPets[petIndex].name,
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

  void _showAddOrUpdatePetDialog({UserPetsModel? pet}) {
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController petBreedController = TextEditingController();
    final TextEditingController petAgeController = TextEditingController();
    String petGender = "Male";
    String petSpecies = "Dog";

    String? petNameError;
    String? petAgeError;

    if (pet != null) {
      petNameController.text = pet.name;
      petSpecies = pet.species;
      petBreedController.text = pet.breed;
      petAgeController.text = pet.age.toString();
      petGender = pet.gender;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(pet == null ? 'Add a New Pet' : 'Update Pet Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: petNameController,
                      decoration: InputDecoration(
                        labelText: 'Pet Name',
                        errorText: petNameError,
                      ),
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                    Row(
                      children: [
                        const Text("Species:", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 18),
                        DropdownButton<String>(
                          value: petSpecies,
                          onChanged: (String? newValue) {
                            setState(() {
                              petSpecies = newValue!;
                            });
                          },
                          items: const <String>['Dog', 'Cat', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    TextField(
                      maxLength: 10,
                      controller: petBreedController,
                      decoration: const InputDecoration(
                        labelText: 'Pet Breed'
                        ),
                    ),
                    TextField(
                      controller: petAgeController,
                      decoration: InputDecoration(
                        labelText: 'Pet Age',
                        errorText: petAgeError,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9]{1,2}$')),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Gender:", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 18),
                        DropdownButton<String>(
                          value: petGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              petGender = newValue!;
                            });
                          },
                          items: const <String>['Male', 'Female']
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
                    String petBreed = petBreedController.text.trim();
                    int petAge =
                        int.tryParse(petAgeController.text.trim()) ?? 0;

                    setState(() {
                      petNameError =
                          petName.isEmpty ? 'Please enter a pet name' : null;
                      petAgeError =
                          petAge <= 0 ? 'Please enter a valid pet age' : null;
                    });

                    if (petName.isNotEmpty && petAge > 0) {
                      final updatedPet = UserPetsModel(
                        petId: pet?.petId ?? DateTime.now().toString(),
                        owner: "owner",
                        name: petName,
                        species: petSpecies,
                        breed: petBreed,
                        age: petAge,
                        gender: petGender,
                      );

                      if (pet == null) {
                        Provider.of<UserPetsProvider>(context, listen: false)
                            .addPet(updatedPet);
                      } else {
                        Provider.of<UserPetsProvider>(context, listen: false)
                            .updatePet(pet.petId, updatedPet);
                      }

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please fill the required fields correctly')),
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
}

class UserPetsContainerForTracker extends StatefulWidget {
  final Function(String petId, String name, String breed, int age, String gender, String species)
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
                      if (userPetsProvider.userPets[petIndex].species ==
                          "Dog") {
                        modelPic =
                            "assets/images/user_pet_model_default_dog.png";
                      } else if (userPetsProvider.userPets[petIndex].species ==
                          "Cat") {
                        modelPic =
                            "assets/images/user_pet_model_default_cat.png";
                      } else {
                        modelPic = "assets/images/user_pet_model_default.png";
                      }

                      return GestureDetector(
                        onTap: () {
                          widget.onPetSelected(
                              userPetsProvider.userPets[petIndex].petId,
                              userPetsProvider.userPets[petIndex].name,
                              userPetsProvider.userPets[petIndex].breed,
                              userPetsProvider.userPets[petIndex].age,
                              userPetsProvider.userPets[petIndex].gender,
                              userPetsProvider.userPets[petIndex].species
                              );
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
                                  userPetsProvider.userPets[petIndex].name,
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
