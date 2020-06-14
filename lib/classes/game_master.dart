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
    List data;
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
            'Peaches': 'Peach',
            'Plums': 'Plum',
          };
          data = await network.getData(
              'https://www.halfyourplate.ca/fruits-and-veggies/fruits-a-z/',
              'ul.fv-list > li > a',
              'ul.fv-list > li > div > span > a > img');
         
        }
        break;
      case "Countries":
        {
          removeTextArray = [
          
          ];
          renameTextMap = {
           
          };
          // data = await network.getData();
          
        }
        break;
    }
     texts = data[0];
          images = data[1];
    filter(texts, images, removeTextArray, renameTextMap);
  }

  filter(List texts, List images, List removeTextArray,
      Map<String, String> renameTextMap) {
    List<String> filteredNames = [];

    texts.forEach((text) {
      String innerText = text.innerHtml;

      if (renameTextMap.keys.contains(innerText)) {
        innerText = renameTextMap[innerText];
      }

      filteredNames.add(innerText);
    });
    for (var i = 0; i < texts.length; i++) {
      String key = filteredNames[i];
      if (!removeTextArray.contains(key)) {
        if(key.contains(' ')){
          key = key.replaceAll(' ', '-');
        }
        textImageMap[key] = images[i].attributes['src'];
      }
    }
  }

  Future<List<ImageCard>> createImageWidgets() async {
    print('create image widgets');
    List<ImageCard> widgets = [];
    textImageMap.forEach((text, url) {
      Image image = Image.network(url);
      widgets.add(ImageCard(text, image));
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
