import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gmap/screens/question_page.dart';
import 'package:speech_recognition/speech_recognition.dart';

class TransactionPage extends StatefulWidget {
  String username;
  int amount;
  TransactionPage(String username, int amount){
    this.username=username;
    this.amount=amount;
  }
  @override
  _TransactionPageState createState() => _TransactionPageState(username, amount);
}

class _TransactionPageState extends State<TransactionPage> {

  String username;
  int amount;
  _TransactionPageState(String username, int amount){
    this.username=username;
    this.amount=amount;
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
    await flutterTts.speak("Say the id to transfer");
  }
  
  _askSecurityQuestion(){
//    var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(username).get();
//    String question = ref["question"].toString();
//    String answer = ref["answer"].toString();
//    String userAnswer="";
//    await flutterTts.speak(question);
//    Future.delayed(const Duration(milliseconds: 2000), () {
//      _speechRecognition
//          .listen(locale: "en_US")
//          .then((result){
//        print('$result');
//        userAnswer = '$result';
//      });
//    });
//    userAnswer = userAnswer.toLowerCase();
//    if(userAnswer==answer){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuestionPage(username, amount, resultText.toLowerCase())),
      );
//    }
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

//  _navigate() async{
//    resultText = resultText.toLowerCase();
//    print(resultText);
//    var ref = await Firestore.instance.collection("login").document("user").collection("moving").document(username).get();
//    int userAmount = int.parse(ref["balance"].toString());
//    await Firestore.instance.collection("login").document("user").collection("moving").document(username).updateData({
//      "balance": userAmount-amount,
//      "id": ref["id"].toString(),
//      "mobile": ref["mobile"].toString(),
//      "password": ref["password"].toString(),
//      "question":ref["question"].toString(),
//      "answer": ref["answer"].toString()
//    });
//    await Firestore.instance.collection("login").document("user").collection("moving").document(username).collection("expenses").add({
//      "amount":amount,
//      "date":DateTime.now(),
//      "receiver" :resultText
//    });
//
//    var ref1 = await Firestore.instance.collection("login").document("user").collection("moving").document(resultText).get();
//    int userAmount1 = int.parse(ref1["balance"].toString());
//    await Firestore.instance.collection("login").document("user").collection("moving").document(resultText).updateData({
//      "balance": userAmount1+amount,
//      "id": ref1["id"].toString(),
//      "mobile": ref1["mobile"].toString(),
//      "password": ref1["password"].toString(),
//      "question":ref1["question"].toString(),
//      "answer": ref1["answer"].toString()
//    });
//    await Firestore.instance.collection("login").document("user").collection("moving").document(resultText).collection("income").add({
//      "amount":amount,
//      "date":DateTime.now(),
//      "receiver" :username
//    });
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => HomePage(username)),
//    );
//  }

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
        title: Text("Transaction"),
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
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 191, 255, 50)
                ),
                child: Center(
                  child: FlatButton(
                    onPressed: _askSecurityQuestion,
                    child: Text("Click"),
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
