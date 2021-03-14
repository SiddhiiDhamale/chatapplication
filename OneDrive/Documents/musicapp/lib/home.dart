import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:audioplayers/audio_cache.dart';

class MyApp extends StatelessWidget {
  void music() {
    var audio = AudioCache();
    audio.play("/flutter_assets/believer.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "MusicalVibes",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: <Widget>[
            Icon(
              Icons.headset_mic,
              size: 33,
              color: Colors.amberAccent,
            ),
          ],
        ),
        body: Row(
          children: [
            Container(
              child: Image.network('https://picsum.photos/seed/picsum/200/300',
                  height: 180, width: 120, fit: BoxFit.fitHeight),
              padding: EdgeInsets.all(10),
              //RaisedButton(),
            ),
            GestureDetector(
              child: FloatingActionButton.extended(
                onPressed: () {
                  music();
                },
                label: Text(
                  'Play',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  Icons.play_arrow,
                  size: 25,
                ),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
