import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0,
            0.5,
            1,
          ],
          colors: [
            Color(0xFF004C95),
            Color(0xFF7807B9),
            Color(0xFF590063),
          ],
        ),
      ),
    );
  }
}

class BackgroundGradientBlue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0,
            1,
          ],
          colors: [
            Color(0xFF005BEA),
            Color(0xFF00C6FB),
          ],
        ),
      ),
    );
  }
}
