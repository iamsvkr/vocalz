import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gmap/screens/amount_page.dart';
import 'package:gmap/screens/map_page.dart';
import 'package:speech_recognition/speech_recognition.dart';

class HomePage extends StatefulWidget {
  String username;
  HomePage(String username){
    this.username=username;
  }

  @override
  _HomePageState createState() => _HomePageState(username);
}

class _HomePageState extends State<HomePage> {

  String username="";
  _HomePageState(String username){
    this.username=username;
  }

  final FlutterTts flutterTts = FlutterTts();
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    _speakAtAppStart();
    initSpeechRecognizer();
    _getText();
    //_navigate();
  }

  _speakAtAppStart() async{
    await flutterTts.speak("Sir please ask your query");
  }

  _speakAtQueryAgain() async{
    await flutterTts.speak("Sir please ask your query");
    resultText="";
    _getText();
    _navigate();
  }

  _getText(){
    Future.delayed(const Duration(milliseconds: 2000), () {
      _speechRecognition
          .listen(locale: "en_US")
          .then((result){
        print('$result');
        resultText = '$result';
      });
    });
  }

  _navigate() async{
    resultText = resultText.toLowerCase();
    print(resultText);
    if(resultText.contains("balance")){
      var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(username).get();
      var balance = ref["balance"];
      await flutterTts.speak("your current balance is "+balance.toString());
    }else if(resultText.contains("income")){
      var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(username).collection("income").getDocuments();
      var len = ref.documents.length;
      print(len);
      String out="";
      for(var i=0; i<len; i++){
        DateTime date = ref.documents[i]["date"].toDate();
        DateTime today = DateTime.now();
        if(date.day==today.day && date.month==today.month && date.year==today.year){
          out=out+"you got "+ref.documents[i]["amount"].toString()+" amount from "+ref.documents[i]["receiver"];
          if(i<len-1){
            out=out+"and";
          }
        }
        if(out!=""){
          await flutterTts.speak(out);
        }else{
          await flutterTts.speak("you have no income");
        }
      }
    }else if(resultText.contains("expenses")){
      var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(username).collection("expenses").getDocuments();
      var len = ref.documents.length;
      print(len);
      String out="";
      for(var i=0; i<len; i++){
        DateTime date = ref.documents[i]["date"].toDate();
        DateTime today = DateTime.now();
        if(date.day==today.day && date.month==today.month && date.year==today.year){
          out=out+"you got "+ref.documents[i]["amount"].toString()+" amount from "+ref.documents[i]["receiver"];
          if(i<len-1){
            out=out+"and";
          }
        }
        if(out!=""){
          await flutterTts.speak(out);
        }else{
          await flutterTts.speak("you have no expenses");
        }
      }
    }else if(resultText.contains("request") && resultText.contains("cash")){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage(username)),
      );
    }else if(resultText.contains("send") && resultText.contains("money")){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AmountPage(username)),
      );
    }
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(77, 77, 77, 30),
      appBar: AppBar(
        title: Text("Query"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: Center(
                child: Image.network("https://image.flaticon.com/icons/png/512/1253/1253687.png"),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              child: Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 191, 255, 50)
                ),
                child: Center(
                  child: FlatButton(
                    onPressed: _navigate,
                    child: Text("Click"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              child: Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 191, 255, 50)
                ),
                child: Center(
                  child: FlatButton(
                    onPressed: _speakAtQueryAgain,
                    child: Text("Query Again"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
