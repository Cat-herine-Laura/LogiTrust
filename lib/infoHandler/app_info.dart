import "package:flutter/cupertino.dart";
import "package:users/models/directions.dart";

class AppInfo extends ChangeNotifier{
  Directions? userPickupLocation, userDropOffLocation;
  int countTotalTrips = 0;
  // List<String> historyTripsKeysList = [];
  // List<TripHistoryModel> allTripsHistoryInformationList = [];

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupAddress = userPickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}