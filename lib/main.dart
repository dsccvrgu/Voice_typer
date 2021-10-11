import 'package:avatar_glow/avatar_glow.dart' show AvatarGlow;
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart' show HighlightedWord, TextHighlight;
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'voice_typer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'Hello': HighlightedWord(
      onTap: () => print('Hello'),
      textStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
    ),
    'google': HighlightedWord(
      onTap: () => print('google'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'love': HighlightedWord(
      onTap: () => print('love'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'ok': HighlightedWord(
      onTap: () => print('ok'),
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VOICE TO TEXT"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body:  Container(
          height: 600,
          child: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 30),),
                  ),
                  Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                  child: TextHighlight(
                    text: _text,
                    words: _highlights,
                    textStyle: const TextStyle(
                      fontSize: 32.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      
                    ),
                  ),
                ),],
              ),
          ),
        ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
