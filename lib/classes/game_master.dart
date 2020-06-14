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
          texts = data[0];
          images = convertLinkToString("Fruits", data[1]);
        }
        break;
      case "Countries":
        {
          removeTextArray = [
            'Åland Islands',
            'American Samoa',
            'Anguila',
            'Antigua and Barbuda',
            'Bosnia and Herzegovina',
            'Bouvet Island',
            'British Indian Ocean Territory',
            'Burkina Faso',
            'Caribbean Netherlands',
            'Cocos Islands',
            'Republic of the Congo',
            'DR Congo',
            "Côte d'Ivoire",
            'French Southern and Antarctic Lands',
            'Guadeloupe',
            'Heard Island and McDonald Islands',
            'Isle of Man',
            'Marshall Islands',
            'Martinique',
            'Mayotte',
            'Réunion',
            'Saint Barthélemy',
            'Saint Helena, Ascension and Tristan da Cunha',
            'Saint Kitts and Nevis',
            'Saint Pierre and Miquelon',
            'Saint Vincent and the Grenadines',
            'São Tomé and Príncipe',
            'Svalbard and Jan Mayen',
            'Trinidad and Tobago',
            'Turks and Caicos Islands',
            'United States Minor Outlying Islands',
            'United States Virgin Islands',
            'British Virgin Islands',
            'Wallis and Futuna',
            
          ];
          renameTextMap = {};
          data = await network.getData(
              'https://flagpedia.net/index',
              'div.flag-container > ul.flag-grid > li > a > span',
              'div.flag-container > ul.flag-grid > li > a > picture > img');

          texts = data[0];
          images = convertLinkToString("Countries", data[1]);
        }
        break;
    }

    filter(texts, images, removeTextArray, renameTextMap);
  }

  convertLinkToString(String type, List imageLinks) {
    List result = [];
    switch (type) {
      case 'Fruits':
        {
          imageLinks.forEach((imageLink) {
            result.add(imageLink.attributes['src']);
          });
        }
        break;
      case 'Countries':
        {
          imageLinks.forEach((imageLink) {
            result.add('https://flagpedia.net/' + imageLink.attributes['src']);
          });
        }
    }

    return result;
  }

  filterCountries(List texts) {
    List result = [];
    texts.forEach((text) {
      print(text.innerHtml);
      // if(!text.innerHtml.contains('<')){
      //   result.add(text);
      // }
    });
    print(result);
    return result;
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
        if (key.contains(' ')) {
          key = key.replaceAll(' ', '-');
        }
        textImageMap[key] = images[i];
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
