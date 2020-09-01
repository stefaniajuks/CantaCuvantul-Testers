import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

Future noCoins(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text(
            "Upss! Esti cam sarac...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Josefin',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  RaisedButton(
                      child: Text(
                        "Watch Ad for 10\$",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        await RewardedVideoAd.instance.show();
                        Navigator.pop(context);
                      }),
                ],
              ),
            ],
          ),
        );
      });
}
