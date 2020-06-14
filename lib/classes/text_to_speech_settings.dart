import 'package:flutter/material.dart';

class TextToSpeechSettings with ChangeNotifier {
  List<String> languages = ['en-US', 'ja-JP'];
  double volume = 1.0;
  double pitch = 1.25;
  double rate = 0.7;

  String test = 'test test';

  printTest() => print(test);

  getVolume() => volume;

  getPitch() => pitch;

  getRate() => rate;

  updateValues(volume, pitch, rate) {
    updateVolume(volume);
    updatePitch(pitch);
    updateRate(rate);
  }

  updateValue(String text, double value){
    switch(text){
      case 'Volume':{
        updateVolume(value);
      }
      break;
      case 'Pitch' : {
        updatePitch(value);
      }
      break;
      case 'Rate' : {
        updateRate(value);
      }
    }
  }

  updateVolume(value) {
    volume = value;
    notifyListeners();
  }

  updatePitch(value) {
    pitch = value;
    notifyListeners();
  }

  updateRate(value) {
    rate = value;
    notifyListeners();
  }

  setDefaultValues() {
    volume = 0.5;
    pitch = 0.75;
    rate = 0.5;
    notifyListeners();
  }
}
