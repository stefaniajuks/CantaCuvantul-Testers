import 'package:cloud_firestore/cloud_firestore.dart';
import 'wordIndex.dart';
import 'package:canta_cuvantul/playerpoints.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'popup_menu.dart';
import 'package:flutter/material.dart';
import 'backgroundGradient.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';
import 'noCoins.dart';
import 'sharedPrefs.dart';
import 'admob_service.dart';

WordIndex wordIndex = WordIndex();
int timeRemaining = 30;
List melodii = [];

class WordsPage extends StatefulWidget {
  @override
  _WordsPageState createState() => _WordsPageState();
}

AudioPlayer audioPlayer = new AudioPlayer();

class _WordsPageState extends State<WordsPage> {
  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  String artist = '';
  String year = '';

  int _random;
  Duration secunde = new Duration(seconds: 100);
  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  int position;
  double isVisible1 = 0;
  double isVisible2 = 0;
  List<bool> pressed = [false, false, false];
  String link = '';
  int resumeTime = 0;
  int _current;

  void onClickMenu(MenuItemProvider item) async {
    int coins = await SharedPreferanceHelper.getCoins();
    print('Click menu -> ${item.menuTitle}');
    if (item.menuTitle == 'An lansare-5') {
      if (!pressed[0]) {
        if (coins - 5 < 0) {
          noCoins(context);
        } else {
          SharedPreferanceHelper.decreaseCoins(coins, 5);
          setState(() {
            isVisible1 = 1;
            pressed[0] = true;
          });
        }
      }
    }
    if (item.menuTitle == 'Artist-10') {
      if (!pressed[1]) {
        if (coins - 10 < 0) {
          noCoins(context);
        } else {
          SharedPreferanceHelper.decreaseCoins(coins, 10);
          setState(() {
            isVisible2 = 1;
            pressed[1] = true;
          });
        }
      }
    }
    if (item.menuTitle == '5 seconds-15') {
      if (!pressed[2]) {
        if (coins - 15 < 0) {
          noCoins(context);
        } else {
          SharedPreferanceHelper.decreaseCoins(coins, 15);
          setState(() {
            pressed[2] = true;
            audioPlayer.play(link);
            Timer.periodic(Duration(seconds: 12), (Timer t) {
              audioPlayer.stop();
            });
          });
        }
      }
    }
  }

  void refresh() {
    setState(() {});
  }

  void initState() {
    super.initState();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.started) {
        setState(() {
          resumeTime = timeRemaining;
          timeRemaining = 900;
        });
      }
      if (event == RewardedVideoAdEvent.rewarded) {
        print("rewarded");
        setState(() async {
          int coin = await SharedPreferanceHelper.getCoins();
          await SharedPreferanceHelper.increaseCoins(coin, rewardAmount);
          refresh();
        });
      }
      if (event == RewardedVideoAdEvent.loaded) {
        print("loaded");
      }
      if (event == RewardedVideoAdEvent.closed) {
        print("closed");
        String adCoinsId = AdMobService().getaddCoisID();
        RewardedVideoAd.instance
            .load(adUnitId: adCoinsId, targetingInfo: targetingInfo)
            .catchError((e) => print("error: ${e.toString()}"));
        setState(() {
          timeRemaining = resumeTime + 1;
        });
      }
    };
    wordIndex.generateRandom();
    _random = wordIndex.getRmd();
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  bool choose = false;
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    _current = wordIndex.getCounter();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Cuvinte').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (choose == false) {
              melodii = snapshot.data.documents[_random]["Melodie"];
              position = Random().nextInt(melodii.length);
              choose = true;
              print(position);
              print(melodii[position]);
            }
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  BackgroundGradientBlue(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          FutureBuilder<int>(
                              future: SharedPreferanceHelper.getCoins(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (!snapshot.hasData)
                                  return Text("NULL");
                                else {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            'assets/coin.svg',
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Runda $_current',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Josefin',
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              'Cuvantul este:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Josefin',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                              ),
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                            Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                snapshot.data.documents[_random]['Nume'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Josefin',
                                  color: Colors.red[600],
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      offset: Offset(0.75, 1),
                                      blurRadius: 7.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: CustomPaint(
                                  painter: CirclePainter(),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  CntTimer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('Melodii')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                artist = snapshot.data
                                    .documents[melodii[position] - 1]["Artist"];
                                year = snapshot.data
                                    .documents[melodii[position] - 1]["An"];
                                link = snapshot.data
                                    .documents[melodii[position] - 1]["Link"];
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Opacity(
                                      opacity: isVisible1,
                                      child: Text(
                                        'Anul aparitiei: ' + year,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Josefin',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: isVisible2,
                                      child: Text(
                                        'Artistul: ' + artist,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Josefin',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                key: btnKey,
                                onTap: () {
                                  maxColumn();
                                },
                                child: Column(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/MusicNote.svg',
                                      height: 50,
                                    ),
                                    Text(
                                      'Hints',
                                      style: TextStyle(
                                        fontFamily: 'Josefin',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      int coins = await SharedPreferanceHelper
                                          .getCoins();

                                      print(coins);
                                      if (coins - 20 > 0) {
                                        SharedPreferanceHelper.decreaseCoins(
                                            coins, 20);
                                        setState(() {
                                          int backuptime = timeRemaining + 10;
                                          timeRemaining = backuptime;
                                        });
                                      } else {
                                        noCoins(context);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '20',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Josefin',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/coin.svg',
                                              height: 18,
                                            ),
                                          ],
                                        ),
                                        SvgPicture.asset(
                                          'assets/Timer.svg',
                                          height: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '+10 seconds',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Josefin',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
        },
      ),
    );
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
        backgroundColor: Colors.black54,
        lineColor: Colors.tealAccent,
        maxColumn: 1,
        items: [
          MenuItem(
            title: 'An lansare-5',
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'Josefin',
            ),
          ),
          MenuItem(
            title: 'Artist-10',
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'Josefin',
            ),
          ),
          MenuItem(
            title: '5 seconds-15',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'Josefin',
            ),
          ),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey);
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 10
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CntTimer extends StatefulWidget {
  @override
  CntTimerState createState() => CntTimerState();
}

class CntTimerState extends State<CntTimer> with TickerProviderStateMixin {
  var colorCurrent = Colors.white;

  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getTime();
      if (timeRemaining == 0) {
        setState(() {
          timer.cancel();
          timeRemaining = 30;
          audioPlayer.stop();
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerPoints()));
      }
    });
    super.initState();
  }

  void _getTime() {
    setState(() {
      timeRemaining == 0 ? timeRemaining = 0 : timeRemaining--;
    });
  }

  @override
  void dispose() {
    timeRemaining = 30;
    timer?.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timeRemaining == 0) dispose();
    if (timeRemaining <= 3) colorCurrent = Colors.red;
    if (timeRemaining >= 4) colorCurrent = Colors.white;
    return Column(
      children: <Widget>[
        Text(
          '$timeRemaining',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorCurrent,
            fontFamily: 'Rubik',
            fontSize: 80,
          ),
        ),
        FlatButton(
          //  elevation: 0,
          //  highlightColor: Colors.transparent,
          color: Colors.transparent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayerPoints(), fullscreenDialog: true),
            );
            setState(() {
              timer.cancel();
              timeRemaining = 30;
              audioPlayer.stop();
            });
          },
          child: Text(
            'Press for next',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontFamily: 'Josefin',
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }
}
