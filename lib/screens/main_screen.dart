// ignore_for_file: unused_field

import "dart:async";
import "package:geocoder2/geocoder2.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:location/location.dart' as loc;
import "package:flutter/material.dart";
import "package:provider/provider.dart";
// import "package:users/Assistants/assistant_methods.dart";
// import "package:users/global/global.dart";
import "package:users/global/map_key.dart";
import "package:users/infoHandler/app_info.dart";
import "package:users/models/directions.dart";
import "package:users/screens/search_places_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();
 
  LocationPermission? _locationPermission;
  double bottomPaddingofMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String username = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  bool darkTheme = false;
  
  get darkness => null;


  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  
    // String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
    // print("This is our address = $humanReadableAddress");

    // username = userModelCurrentInfo!.name;
    // userEmail = userModelCurrentInfo!.email;

    // initializeGeoFireListener();

    // AssistantMethods.readTripsKeyForOnlineUser(context);

  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: mapKey
      );
      setState(() {
        Directions userPickupAddress = Directions();
        userPickupAddress.locationLatitude = pickLocation!.latitude;
        userPickupAddress.locationLongitude = pickLocation!.longitude;
        userPickupAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(userPickupAddress);
        // _address = data.address;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  checkLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    
    checkLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingofMap = 200;
                });

                locateUserPosition(); 
              },
              onCameraMove: (CameraPosition position) {
                if (pickLocation != position.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                // getAddressFromLatLng();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset("images/pick.png", height: 45, width: 45,),
              ),
            ),

            // UI for searching location
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("From",
                                          style: TextStyle(
                                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          Provider.of<AppInfo>(context).userPickupLocation != null 
                                          ? "${(Provider.of<AppInfo>(context).userPickupLocation!.locationName!).substring(0, 24)}..." : "Not Getting Address",
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 5,),

                                  Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: darkness ? Colors.amber.shade400 : Colors.blue,

                                  ),
                                  const SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        //go to search places screen
                                        var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> const SearchPlacesScreen()));

                                        if(responseFromSearchScreen == "obtainedDropOff"){
                                          setState(() {
                                            openNavigationDrawer = false;
                                          });
                                        }
                                      },
                                      child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("To",
                                          style: TextStyle(
                                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          Provider.of<AppInfo>(context).userDropOffLocation != null 
                                          ? "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!).substring(0, 24)}..." 
                                          : "Where to?",
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        )
                                      ],
                                    ),
                                    ),
                                  ),

                                ],
                              ),
                          )
                        ],
                      ),
                    ),
                   ],
                  )
                ),
              ),

            
            // Positioned(
            //   top: 40,
            //   right: 20,
            //   left: 20,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black),
            //       color: Colors.white,
            //     ),
            //     padding: EdgeInsets.all(20),
            //     child: Text(
            //       Provider.of<AppInfo>(context).userPickupLocation != null 
            //       ? (Provider.of<AppInfo>(context).userPickupLocation!.locationName!).substring(0, 24) + "..." : "Not Getting Address",
            //       overflow: TextOverflow.visible,
            //       softWrap: true,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
