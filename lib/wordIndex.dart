import 'dart:math';

int _rmd = Random().nextInt(7);
int _counter = 1;

class WordIndex {
  WordIndex();
  void generateRandom() {
    _rmd = Random().nextInt(7);
  }

  void counterIncrease() {
    _counter++;
  }

  bool isOk() {
    if (_counter < 10)
      return true;
    else
      return false;
  }

  int getRmd() {
    //  print(_rmd);
    return _rmd;
  }

  void resetCounter() {
    _counter = 1;
  }

  int getCounter() {
    return _counter;
  }
}
