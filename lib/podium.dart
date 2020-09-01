import 'package:canta_cuvantul/admob_service.dart';
import 'package:canta_cuvantul/main.dart';
import 'package:flutter/material.dart';
import 'package:canta_cuvantul/playerspage.dart';
import 'backgroundGradient.dart';
import 'package:canta_cuvantul/users.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'wordIndex.dart';

class Podium extends StatefulWidget {
  Podium({Key key}) : super(key: key);

  @override
  _PodiumState createState() => _PodiumState();
}

User aux;
String finishAd = AdMobService().getfinishADID();
void sortArray() {
  for (int i = 0; i < counter; i++)
    for (int j = 0; j < counter - i - 1; j++) {
      if (useri[j].points < useri[j + 1].points) {
        aux = useri[j];
        useri[j] = useri[j + 1];
        useri[j + 1] = aux;
      }
    }

  for (int i = 0; i < counter; i++) print(useri[i].name);
}

class _PodiumState extends State<Podium> {
  @override
  Widget build(BuildContext context) {
    sortArray();
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
                    "Clasamentul este:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Josefin',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: counter,
                    itemBuilder: (_, index) {
                      return FlatButton(
                        onPressed: null,
                        child: Card(
                          // shadowColor: Colors.black,
                          color: useri[index].points == useri[0].points
                              ? Colors.orange
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("#" + '${index + 1}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(useri[index].name),
                                    Divider(
                                      height: 5,
                                    ),
                                    Text('Puncte: ${useri[index].points}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                                Image.asset(
                                  useri[index].caracter,
                                  width: 70,
                                  height: 70,
                                  //fit: BoxFit.fitWidth,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    useri = [];
                    WordIndex().resetCounter();
                    counter = 0;
                    myInterstitial
                      ..load()
                      ..show(
                        anchorType: AnchorType.bottom,
                        anchorOffset: 0.0,
                        horizontalCenterOffset: 0.0,
                      );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartPage(),
                          fullscreenDialog: true),
                    );
                  },
                  child: Text(
                    'Inapoi la ecranul principal',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>[],
  contentUrl: 'https://flutter.io',
  // birthday: DateTime.now(),
  childDirected: false,
  // designedForFamilies: false,
  // gender:
  //   MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: finishAd,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);
