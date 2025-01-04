// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:petify/containers/home_page_store_maker_container.dart';
import 'package:petify/models/user_pets_model.dart';
import 'package:petify/styles/app_styles.dart';
import 'package:petify/styles/default_search_bar.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<UserPetsModel> userPets = [];

  void _getUserPetsModels() {
    userPets = UserPetsModel.getUserPets();
  }

  @override
  void initState() {
    _getUserPetsModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getUserPetsModels();
    return Scaffold(
      backgroundColor: Color(0xFFeeedf2),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Good Morning",
                              style: AppStyles.headlineStyle3),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Lihindu Perera",
                            style: AppStyles.headlineStyle1,
                          ),
                        ],
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/user.png"))),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RepaintBoundary(child: const DefaultSearchBar())
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
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
                const SizedBox(
                  height: 5,
                ),
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
                            // Handle adding pet (e.g., navigate to a screen to add pet)
                            // For example, you can navigate to a pet adding page here:
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddPetPage()));
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
                                const Icon(Icons.add,
                                    size: 30, color: Colors.blue),
                                const Text("Add Pets")
                              ],
                            ),
                          ),
                        );
                      } else {
                        int petIndex = index - 1;
                        String modelPic;
                        if (userPets[petIndex].petType == "Dog") {
                          modelPic =
                              "assets/images/user_pet_model_default_dog.png";
                        } else if (userPets[petIndex].petType == "Cat") {
                          modelPic =
                              "assets/images/user_pet_model_default_cat.png";
                        } else {
                          modelPic = userPets[petIndex].iconPath;
                        }
                        return Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: userPets[petIndex].boxColor.withOpacity(0.3),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
