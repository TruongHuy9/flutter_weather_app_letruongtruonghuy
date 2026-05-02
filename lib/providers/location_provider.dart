import 'package:flutter/material.dart';
import '../models/location_model.dart';

class LocationProvider extends ChangeNotifier {
  LocationModel? currentLocation;

  void setLocation(LocationModel location) {
    currentLocation = location;
    notifyListeners();
  }
}