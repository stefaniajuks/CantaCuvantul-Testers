import 'package:canta_cuvantul/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chooseMode.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'backgroundGradient.dart';
import 'dropdownCoins.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'sharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

const testDevice = 'Your_DeviceID';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

int coins = 0;

class _StartPageState extends State<StartPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {
      // Not first time
      coins = prefs.getInt('coins');
      print("Not first time");
      print(coins);
    } else {
      // First time
      prefs.setBool('first_time', false);
      prefs.setInt('coins', 100);
      print("First time");
    }
  }

  getCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins');
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isFirstTime();
    String admobId = AdMobService().getAdMobID();
    FirebaseAdMob.instance.initialize(appId: admobId);
    String adCoinsID = AdMobService().getaddCoisID();
    RewardedVideoAd.instance
        .load(adUnitId: adCoinsID, targetingInfo: targetingInfo)
        .catchError((e) => print("error: ${e.toString()}"));
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.failedToLoad) {
        print("Nu merge bosssss");
      }
      if (event == RewardedVideoAdEvent.closed) {
        print("closed");
        RewardedVideoAd.instance
            .load(
                adUnitId: RewardedVideoAd.testAdUnitId,
                targetingInfo: targetingInfo)
            .catchError((e) => print("error: ${e.toString()}"));
      }
      if (event == RewardedVideoAdEvent.rewarded) {
        print("rewarded");
        setState(() async {
          int coin = await SharedPreferanceHelper.getCoins();
          await SharedPreferanceHelper.increaseCoins(coin, rewardAmount);
          refresh();
        });
      }
    };
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0),
              ),
              child: Container(
                color: Color(0xFFF5A307),
                child: ListView(
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      alignment: Alignment.topLeft,
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text(
                        'Cum se joaca?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Josefin',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundGradient(),
          SvgPicture.asset('assets/StartPage1.svg'),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                    iconSize: 35,
                    //   padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  Row(
                    children: <Widget>[
                      FutureBuilder<int>(
                          future: SharedPreferanceHelper.getCoins(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
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
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(52, 120, 53, 0),
                  child: Container(
                    child: SvgPicture.asset('assets/Titlu1.svg'),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Container(
                        width: 142,
                        height: 142,
                        child: FittedBox(
                          child: CircularGradientButton(
                            child: Text(
                              'Play',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Josefin',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            callback: () {
                              return chooseMode(context);
                            },
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0,
                                0.5,
                                1,
                              ],
                              colors: [
                                Color(0xFFFC4850),
                                Color(0xFFFC4850),
                                Color(0xFFFF7B36),
                              ],
                            ),
                            shadowColor: Gradients.deepSpace.colors.last
                                .withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.deepOrange[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(13.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Josefin',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/coin.svg',
                              height: 25,
                            ),
                          ],
                        ),
                        onPressed: () {
                          buildShowModalBottomSheet(context);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
