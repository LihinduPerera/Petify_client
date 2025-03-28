import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/categories_model.dart';
import 'package:petify/models/products_model.dart';
import 'package:petify/models/promo_banners_model.dart';

class ShopProvider extends ChangeNotifier{
  final DBService dbservice = DBService();

  List<ProductsModel> _products = [];
  List<CategoriesModel> _categories = [];
  List<PromoBannersModel> _promos = [];
  List<PromoBannersModel> _banners =  [];

  StreamSubscription<List<CategoriesModel>>? _categorySubscription;
  StreamSubscription<List<PromoBannersModel>>? _bannerSubscription;

  List<CategoriesModel> get categories => _categories;
  List<PromoBannersModel> get banners => _banners;

  bool isLoading = true;

  ShopProvider() {
    fetchCategories();
    fetchBanners();
  }
  
  Future<void> fetchCategories() async{
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_){
        notifyListeners();
      });

      _categorySubscription = dbservice.readCategories().asBroadcastStream().listen((categories){
        _categories.addAll(categories);
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_){
          notifyListeners();
        });
      });

    } catch (e) {
      print('Error while fetching categoris : $e');
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_){
        notifyListeners();
      });
    }
  }

  Future<void> fetchBanners () async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _bannerSubscription = dbservice.readBanners().asBroadcastStream().listen((banners) {
        _banners.addAll(banners);
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      });

    } catch (e) {
      print('Err while fetching Banners : $e');
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
  
}