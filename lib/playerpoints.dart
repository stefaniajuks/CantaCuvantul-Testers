import 'package:canta_cuvantul/playerspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wordspage.dart';
import 'package:flutter/material.dart';
import 'backgroundGradient.dart';
import 'wordIndex.dart';
import 'package:audioplayers/audioplayers.dart';
import 'podium.dart';
//import 'sizehelpers.dart';

WordIndex wordInd = WordIndex();

class PlayerPoints extends StatefulWidget {
  @override
  _PlayerPointsState createState() => _PlayerPointsState();
}

class _PlayerPointsState extends State<PlayerPoints> {
  int flexratio;

  Icon buton = Icon(Icons.play_circle_outline);
  List<Color> _playercolor = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];

  bool play = false;
  Color pointsColor = Colors.black;
  void ratio() {
    if (counter == 2)
      flexratio = 6;
    else if (counter == 3 || counter == 4)
      flexratio = 3;
    else if (counter == 5 || counter == 6) flexratio = 1;
  }

  @override
  void initState() {
    ratio();

    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6 - i - 1; j++) {
        if (useri[j].name == '') {
          aux = useri[j];
          useri[j] = useri[j + 1];
          useri[j + 1] = aux;
        }
      }
    for (int i = 0; i < counter; i++) print(useri[i].name);
    super.initState();
  }

  AudioPlayer audioPlayer = new AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Melodii').snapshots(),
          // initialData: List(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    BackgroundGradient(),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Text(
                              'Adauga puncte: ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Josefin',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: counter,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                mainAxisSpacing: 20,
                              ),
                              itemBuilder: (_, int index) {
                                //  final item = snapshot.data[position];
                                //get your item data here ...

                                return FlatButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      if (_playercolor[index] == Colors.black) {
                                        useri[index].points++;
                                        _playercolor[index] = Colors.red;
                                      } else {
                                        useri[index].points--;
                                        _playercolor[index] = Colors.black;
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: _playercolor[index] == Colors.red
                                        ? Colors.blue[300]
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 0.8,
                                          child: Image.asset(
                                            useri[index].caracter,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              useri[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Divider(
                                              height: 5,
                                            ),
                                            Text(
                                                'Puncte: ${useri[index].points}',
                                                style: TextStyle(
                                                  color: _playercolor[index],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(15),
                              child: Text('Melodii posibile: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'Josefin',
                                    fontWeight: FontWeight.bold,
                                  ))),
                          Expanded(
                            flex: flexratio,
                            child: ListView.builder(
                              itemCount: melodii.length,
                              itemBuilder: (_, int position) {
                                return FlatButton(
                                  onPressed: () {},
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    color: Colors.amber[800],
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.documents[
                                                melodii[position] - 1]["Nume"],
                                          ),
                                          IconButton(
                                            icon: buton,
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () async {
                                              if (play == false) {
                                                await audioPlayer.play(snapshot
                                                            .data.documents[
                                                        melodii[position] - 1]
                                                    ["Link"]);
                                                setState(() {
                                                  buton = Icon(Icons
                                                      .pause_circle_outline);
                                                  play = true;
                                                });
                                              } else {
                                                await audioPlayer.stop();
                                                setState(() {
                                                  buton = Icon(Icons
                                                      .play_circle_outline);
                                                  play = false;
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Artist: " +
                                              snapshot.data.documents[
                                                      melodii[position] - 1]
                                                  ["Artist"]),
                                          Text(
                                              "An: ${snapshot.data.documents[melodii[position] - 1]["An"]}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 130),
                            child: RaisedButton(
                              color: Color(0xFF558B2F),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                              ),
                              onPressed: () {
                                if (WordIndex().isOk() == true) {
                                  WordIndex().generateRandom();
                                  WordIndex().counterIncrease();
                                  print(WordIndex().getCounter());
                                  audioPlayer.stop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WordsPage(),
                                        fullscreenDialog: true),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Podium(),
                                        fullscreenDialog: true),
                                  );
                                }
                              },
                              child: Text(
                                WordIndex().isOk() == true
                                    ? 'Next Round'
                                    : "Finish",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
