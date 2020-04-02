import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmap/screens/login_page.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'choice_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _id = TextEditingController();
  final _password = TextEditingController();
  String dropdownValue = 'moving';

  _register(String id, String password) async{
    if(dropdownValue=="moving"){
      await Firestore.instance.collection("login").document("user").collection("moving").document(id).setData({
        "id": id,
        "password": password
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }else{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      //List<Placemark> placemark = await Geolocator().placemarkFromAddress(position.toString());
      await Firestore.instance.collection("login").document("user").collection("fixed").document(id).setData({
        "id": id,
        "password": password,
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString()
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(
            width: 300,
            height: 300,
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.redAccent,
                          shape: BoxShape.rectangle
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['moving', 'fixed']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    TextFormField(
                      controller: _id,
                      decoration: InputDecoration(labelText: 'Id'),
                      keyboardType: TextInputType.text,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: RaisedButton(
                        child: Text('REGISTER'),
                        onPressed: ()=>_register(_id.text.toString(), _password.text.toString()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor:
                        Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
