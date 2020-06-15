import 'package:education_calculator/classes/filter.dart';
import 'package:education_calculator/classes/network.dart';
import 'package:education_calculator/components/image_card.dart';
import 'package:education_calculator/components/letter_placeholder.dart';
import 'package:flutter/material.dart';

class GameMaster with ChangeNotifier {
  Map filteredTextImage;

  initializeGame(category) async {
    List textArray;
    List imageArray;
    List removeTextArray;
    Map renameTextMap;

    Network network = Network();
    List data;
    Filter filter;
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
          filter = Filter(removeTextArray, renameTextMap);
          textArray = data[0];
          imageArray = data[1];
          filteredTextImage = filter.filter(textArray, imageArray);
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
          filter = Filter(removeTextArray, renameTextMap);
          data = await network.getData(
              'https://flagpedia.net/index',
              'div.flag-container > ul.flag-grid > li > a > span',
              'div.flag-container > ul.flag-grid > li > a > picture > img');
          textArray = data[0];
          imageArray = filter.addFullLink('https://flagpedia.net/', data[1]);
          filteredTextImage = filter.filter(textArray, imageArray);


        }
        break;
    }

  }

  Future<List<ImageCard>> createImageWidgets() async {
    print('create image widgets');
    List<ImageCard> widgets = [];
    filteredTextImage.forEach((text, url) {
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
