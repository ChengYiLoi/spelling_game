import 'package:education_calculator/classes/network.dart';
import 'package:education_calculator/components/image_card.dart';
import 'package:education_calculator/components/letter_placeholder.dart';
import 'package:flutter/material.dart';

class GameMaster with ChangeNotifier {

  Map<String, String> textImageMap = {};

  initializeGame(category) async {
    List texts;
    List images;
    List removeTextArray;
    Map<String, String> renameTextMap;

    Network network = Network();

    switch (category) {
      case 'Fruits':
        {
          removeTextArray = [
            'Acerola – West Indian Cherry',
            'Jujube Fruit',
            'Plantain',
            'Rhubarb',
            'Sapote, Mamey',
            'Java-Plum'
          ];
          renameTextMap = {
            'Pitaya (Dragonfruit)': 'Dragonfruit',
            'Coconut Meat': 'Coconut',
            'Date Fruit': 'Date',
            'Honeydew Melon': 'Honeydew',
            'Persimmon – Japanese': 'Persimmon',
            'Passion Fruit' : 'Passion-Fruit',
            'Peaches' : 'Peach',
            'Plums' : 'Plum',
            'Prickly Pear' : 'Prickly-Pear'
          };
          List data = await network.getData(
              'https://www.halfyourplate.ca/fruits-and-veggies/fruits-a-z/',
              
              'ul.fv-list > li > a',
              'ul.fv-list > li > div > span > a > img');
          texts = data[0];
          images = data[1];
        }
    }
    filter(texts, images, removeTextArray, renameTextMap);
  }

  filter(List texts, List images, List removeTextArray,
      Map<String, String> renameTextMap) {
    List<String> filteredNames = [];

    texts.forEach((text) {
      if (renameTextMap.keys.contains(text.innerHtml)) {
        filteredNames.add(renameTextMap[text.innerHtml]);
      } else {
        filteredNames.add(text.innerHtml);
      }
    });
    for (var i = 0; i < texts.length; i++) {
      textImageMap[filteredNames[i]] = images[i].attributes['src'];
    }
    textImageMap.removeWhere((key, value) => removeTextArray.contains(key));
  }

  Future <List<ImageCard>> createImageWidgets() async {
    print('create image widgets');
    List<ImageCard> widgets = [];
    textImageMap.forEach((text, url) {
 
      widgets.add(ImageCard(text, url));
    });
    return widgets;
  }

  updateLetterPlaceholders(String name) {
    List<String> nameList = name.split('');
    List<Widget> letterWidgetsArray = [];
    nameList.forEach((letter) {
      letterWidgetsArray.add(
        LetterPlaceholder(letter == '-' ? '-' : ' '),
      );
    });
    return letterWidgetsArray;
  }
  
}
