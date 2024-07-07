// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users/Assistants/request_assistant.dart';
import 'package:users/global/global.dart';
import 'package:users/infoHandler/app_info.dart';
import 'package:users/models/user_model.dart';  // Make sure to import your UserModel
import '../global/map_key.dart';
import '../models/directions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser.uid);

      DataSnapshot snap = await userRef.get();

      if (snap.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap);
      }
    }
  }

  static Future<String> searchAddressForGeographicCoordinates(Position position, BuildContext context) async {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occured. Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      // Update the pickup location address using Provider
      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(userPickupAddress);
    }

    return humanReadableAddress;
  }
}
