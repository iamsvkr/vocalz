import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmap/screens/register_page.dart';
import 'dart:async';

import 'choice_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _id = TextEditingController();
  final _password = TextEditingController();

  _login(String id, String password) async{
    var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(id).get();
    if(password == ref["password"].toString() && ref.exists){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChoicePage()),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
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
            height: 240,
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                        child: Text('LOGIN'),
                        onPressed: ()=>_login(_id.text.toString(), _password.text.toString()),
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
