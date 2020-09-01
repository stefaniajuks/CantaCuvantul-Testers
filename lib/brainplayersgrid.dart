class BrainPlayer {
  int cardIndex = 1;
  List<bool> card = [true, false, false, false, false, false];
  int increaseIndex() {
    cardIndex++;
    return cardIndex;
  }

  void isVisible() {
    card[cardIndex] = true;
  }

  void checkPos() {
    if (card[cardIndex - 1] == true) {
      isVisible();
      increaseIndex();
    }
  }

  void resetPos() {
    card[1] = false;
    card[2] = false;
    card[3] = false;
    card[4] = false;
    card[5] = false;
    cardIndex = 1;
  }
}
