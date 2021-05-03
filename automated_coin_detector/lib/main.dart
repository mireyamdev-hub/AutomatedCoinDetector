import 'dart:async';
import 'dart:io';

import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

Timer timer;
String word2;
String word;
Timer _everySecond;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  StreamSubscription _subscription;
  String word;
  String date;
  final List<String> names = <String>[];
  final List<String> dates = <String>[];
  /*AnimationController animation;
  Animation<double> _fadeIn;*/
  double opacityLevel = 1.0;
  List<Map> list = [
    {
      "name": "",
    }
  ];
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  String url =
      'https://assets.mixkit.co/sfx/preview/mixkit-magical-coin-win-1936.mp3';

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });
    /*animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeIn = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animation);
    */
    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });*/
    // animation.forward();
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (!mounted) return;
      setState(() {
        wordsInTime();
      });
    });
  }

  //Widget build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text(list[0]["name"]),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: AnimatedOpacity(
                    //opacity: _fadeIn,
                    opacity: 1,
                    duration: Duration(seconds: 1),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                      child: ExpansionTile(
                        title: Text('${names[index]}'),
                        children: <Widget>[
                          Text('${dates[index]}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  //Method that generates words 'Real' and 'Fake' once every 2 seconds.
  void wordsInTime() {
    var list = ['Real', 'Fake'];
    var randomWord = getRandomElement(list);
    Stream<String> stream = new Stream.fromFuture(getData(randomWord));
    _subscription = stream.listen((data) async {
      word = data;
      names.insert(0, word);
      changeTitle(0, word);
      /*if(word == "Real"){
      await playLocalAsset(); //playSound();
      audioCache.play('coin_effect.wav');
      }*/
      print(data);
      timestamp();
    });
      play();
  }

  //It return the word generated randomly in wordsInTime()
  Future<String> getData(randomWord) async {
    word = randomWord;
    return word;
  }

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  //Change the App title to be updated as the last value received.
  void changeTitle(int index, String word) {
    setState(() {
      list[index]["name"] = word;
    });
  }

  //Generates datetime and inserts it into a List to show it in widget.
  String timestamp() {
    DateTime _now = DateTime.now();
    date = '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}';
    print(
        'timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}');
    dates.insert(0, date);
    return date;
  }

  //Sound tries section
  /*Future<AudioPlayer> playLocalAsset(){
    AudioCache cache = new AudioCache();
    return cache.play("coinEffect.wav");
  }*/
  /*void playSound() {
  AudioCache player = new AudioCache();
  const alarmAudioPath = "coin_effect.wav";
  player.play(alarmAudioPath);  
  }
  */

  //Sound play and pause methods audioPlayer
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  play() async {
    await audioPlayer.play(url);
  }

}
