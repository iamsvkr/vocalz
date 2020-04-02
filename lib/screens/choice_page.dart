import 'package:flutter/material.dart';
import './map_page.dart';

class ChoicePage extends StatefulWidget {
  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choice"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        height: 60.0,
                        child: RawMaterialButton(
                          fillColor: Colors.purple,
                          shape: CircleBorder(),
                          elevation: 0.0,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: (){},
                        ),
                      ),
                      SizedBox(width: 40,),
                      Container(
                        width: 60.0,
                        height: 60.0,
                        child: RawMaterialButton(
                          fillColor: Colors.purple,
                          shape: CircleBorder(),
                          elevation: 0.0,
                          child: Icon(
                            Icons.call_received,
                            color: Colors.white,
                          ),
                          onPressed: (){
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => MapPage()),
//                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
