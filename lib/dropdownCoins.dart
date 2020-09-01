import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future buildShowModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Color(0xFF005BEA),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 36,
              ),
              SizedBox(
                height: (56 * 6).toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: Colors.blueGrey[900],
                  ),
                  child: Stack(
                    alignment: Alignment(0, 0),
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        top: -36,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF005BEA),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                  color: Color(0xFF005BEA), width: 10)),
                          child: Center(
                            child: ClipOval(
                              child: SvgPicture.asset(
                                'assets/coin.svg',
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Free coins',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Josefin',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            CoinsRow(money: 10, price: 'Watch Ad'),
                            Text(
                              'Paid',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Josefin',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            CoinsRow(money: 20, price: '5\$'),
                            CoinsRow(money: 35, price: '7\$'),
                            CoinsRow(money: 50, price: '10\$'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
}

class CoinsRow extends StatelessWidget {
  final int money;
  final String price;
  const CoinsRow({
    Key key,
    this.money,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$money',
                  style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Josefin',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/coin.svg',
                  height: 18,
                ),
              ],
            ),
          ],
        ),
        RaisedButton(
          onPressed: () async {
            if (price == 'Watch Ad') {
              await RewardedVideoAd.instance.show().catchError(
                  (e) => print("Error in showind ad: ${e.toString()}"));
            }
          },
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(13.0),
          ),
          child: Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Josefin',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
