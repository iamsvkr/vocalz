import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_sms/flutter_sms.dart';

class MapPage extends StatefulWidget {
  String username;
  MapPage(String username){
    this.username = username;
  }

  @override
  _MaPageState createState() => _MaPageState(username);
}

class _MaPageState extends State<MapPage> {
  List<Marker> allMarkers = [];

  String username;
  _MaPageState(String username){
    this.username = username;
  }

  String message="";

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents).catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _request() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      allMarkers.add(
          Marker(
            markerId: MarkerId("my_current_location"),
            draggable: false,
            onTap: (){
              print('Marker Tap2');
            },
            position: LatLng(position.latitude, position.longitude),
          )
      );
    });
    List<String> recipents = [];
    message = position.latitude.toString()+" "+position.longitude.toString();
    var markers = await Firestore.instance.collection("login").document("user").collection("fixed").getDocuments();
    var len = markers.documents.length;
    for(var i=0; i<len; i++){
      print(double.parse(markers.documents[i]["latitude"]));
      double lat = double.parse(markers.documents[i]["latitude"]);
      double lan = double.parse(markers.documents[i]["longitude"]);
      setState(() {
        allMarkers.add(
          Marker(
            markerId: MarkerId(markers.documents[i]["id"]),
            draggable: false,
            onTap: (){
              print('Marker Tap1');
            },
            position: LatLng(lat, lan),
          )
        );
      });
      recipents.add(markers.documents[i]["mobile"].toString());
    }
    _sendSMS(message, recipents);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(77, 77, 77, 30),
      appBar: AppBar(
        title: Text("Map"),
      ),

      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(18.6069, 73.8751),
                    zoom: 20.0,
                  ),
                  markers: Set.from(allMarkers),
                ),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: FlatButton(
                    onPressed: (){
                      _request();
                    },
                    child: Text("request"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
