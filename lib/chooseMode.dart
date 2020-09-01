import 'package:flutter/material.dart';
import 'playerspage.dart';

Future chooseMode(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.black45,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: (250).toDouble(),
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      color: Colors.grey[800],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerPage()),
                                );
                              },
                              backgroundColor: Colors.red,
                              child: Text(
                                'Multiplayer',
                                style: TextStyle(
                                  fontFamily: 'Josefin',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: FloatingActionButton(
                              onPressed: null,
                              backgroundColor: Colors.grey,
                              child: Text(
                                'Solo Mode Coming soon',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
