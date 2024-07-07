import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/Assistants/request_assistant.dart';
import 'package:users/global/global.dart';
import 'package:users/global/map_key.dart';
import 'package:users/infoHandler/app_info.dart';
import 'package:users/models/directions.dart';
import 'package:users/models/predicted_places.dart';
import 'package:users/widgets/progress_dialog.dart';
class PlacePredictionTileDesign extends StatefulWidget {

  final PredictedPlaces? predictedPlaces;

  const PlacePredictionTileDesign({super.key, this.predictedPlaces});

 
  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
  }

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  
  getPlaceDirectionDetails(String? placeId, context) async{
    showDialog(
      context: context, 
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting up Drop-off. Please wait.....",
      ),
    );
    
    String getPlaceDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssistant.receiveRequest(getPlaceDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred. Failed. No Response."){
      return;
    }

    if(responseApi["status" == "OK"]) {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geomtry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geomtry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });
    }

  }

  @override
  Widget build(BuildContext context){

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ElevatedButton(
      onPressed: (){
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
