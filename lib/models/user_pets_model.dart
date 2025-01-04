import 'package:flutter/material.dart';

class UserPetsModel {
  String petType;
  String petName;
  String iconPath;
  Color boxColor;

  UserPetsModel({
    required this.petType,
    required this.petName,
    required this.iconPath,
    required this.boxColor,
  });

  static List<UserPetsModel> getUserPets() {
    List<UserPetsModel> userPets = [];

    userPets.add(UserPetsModel(
        petType: "Cat",
        petName: "Patti",
        iconPath: 'assets/images/user.png',
        boxColor: Color(0xff92A3FD)));

    userPets.add(UserPetsModel(
        petType: "Dog",
        petName: "Lipy",
        iconPath: 'assets/images/user.png',
        boxColor: Color(0xffc58BF2)));

    userPets.add(UserPetsModel(
        petType: "Dog",
        petName: "Lipy",
        iconPath: 'assets/images/user.png',
        boxColor: Color(0xffc58BF2)));

    userPets.add(UserPetsModel(
        petType: "Dog",
        petName: "Lipy",
        iconPath: 'assets/images/user.png',
        boxColor: Color(0xffc58BF2)));

    userPets.add(UserPetsModel(
        petType: "Dog",
        petName: "Lipy",
        iconPath: 'assets/images/user.png',
        boxColor: Color(0xffc58BF2)));

    return userPets;
  }
}
