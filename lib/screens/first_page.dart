import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gmap/screens/login_page.dart';
import 'package:gmap/screens/username_page.dart';
import 'package:speech_recognition/speech_recognition.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

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
    _navigate();
  }

  _speakAtAppStart() async{
    await flutterTts.speak("Hello Sir, which language you want to select");
  }

  _getText(){
    Future.delayed(const Duration(milliseconds: 2000), () {
      _speechRecognition
          .listen(locale: "en_US")
          .then((result){
            print('$result');
            resultText = '$result';
//            print(resultText);
//            if(resultText.contains("English")){
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => UsernamePage()),
//              );
//            }
          });
    });
  }

  _navigate(){
    print(resultText);
    if(resultText.contains("English")){
//      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UsernamePage()),
        );
//      });
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
        title: Text("Vocalz"),
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
//                FloatingActionButton(
//                  child: Icon(Icons.cancel),
//                  mini: true,
//                  backgroundColor: Colors.deepOrange,
//                  onPressed: () {
//                    if (_isListening)
//                      _speechRecognition.cancel().then(
//                            (result) => setState(() {
//                          _isListening = result;
//                          resultText = "";
//                        }),
//                      );
//                  },
//                ),
//                FloatingActionButton(
//                  child: Icon(Icons.mic),
//                  onPressed: () {
//                    if (_isAvailable && !_isListening)
//                      _speechRecognition
//                          .listen(locale: "en_US")
//                          .then((result) => print('$result'));
//                  },
//                  backgroundColor: Colors.pink,
//                ),
//                FloatingActionButton(
//                  child: Icon(Icons.stop),
//                  mini: true,
//                  backgroundColor: Colors.deepPurple,
//                  onPressed: () {
//                    if (_isListening)
//                      _speechRecognition.stop().then(
//                            (result) => setState(() => _isListening = result),
//                      );
//                  },
//                ),
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
                    onPressed: _navigate,
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
