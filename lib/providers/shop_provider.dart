import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/categories_model.dart';
import 'package:petify/models/promo_banners_model.dart';

class ShopProvider extends ChangeNotifier {
  final DBService dbservice = DBService();

  List<CategoriesModel> _categories = [];
  List<PromoBannersModel> _promos = [];
  List<PromoBannersModel> _banners = [];

  StreamSubscription<List<CategoriesModel>>? _categorySubscription;
  StreamSubscription<List<PromoBannersModel>>? _bannerSubscription;
  StreamSubscription<List<PromoBannersModel>>? _promoSubscription;

  List<CategoriesModel> get categories => _categories;
  List<PromoBannersModel> get banners => _banners;
  List<PromoBannersModel> get promos => _promos;

  bool isLoading = true;

  ShopProvider() {
    fetchCategories();
    fetchBanners();
    fetchPromos();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _categorySubscription =
          dbservice.readCategories().asBroadcastStream().listen((categories) {
        _categories.addAll(categories);
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      });
    } catch (e) {
      print('Error while fetching categoris : $e');
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> fetchBanners() async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _bannerSubscription =
          dbservice.readBanners().asBroadcastStream().listen((banners) {
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

  Future<void> fetchPromos() async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _promoSubscription =
          dbservice.readPromos().asBroadcastStream().listen((promos) {
        _promos.addAll(promos);
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      });
    } catch (e) {
      print('Error while fetching promos : $e');
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void cancelProvider () {
    _categorySubscription?.cancel();
    _categorySubscription = null;
    _promoSubscription?.cancel();
    _promoSubscription = null;
    _bannerSubscription?.cancel();
    _bannerSubscription = null;
    _categories = [];
    _promos = [] ;
    _banners = [];
  }
}
