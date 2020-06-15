import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

filterTexts(List texts){
  List result = [];
  texts.forEach((text) {
    if(!text.innerHtml.contains('<')){
      result.add(text);
    }
   });
   return result;
}
filterImages(List images){
  List result = [];
  images.forEach((image) {
    if(image.attributes['src'].toString().contains('flags96')){
      result.add(image);
    }
  });
  return result;
}

class Network {
  Future getData(String url, String textElementLocation,
      String imageElementLocation) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print('data retrieved');
      List textArray = [];
      List imageArray = [];
      List texts = [];
      List images = [];
      try {
        dom.Document document = parser.parse(response.body);
        textArray = document.getElementsByTagName(textElementLocation);
        imageArray = document.getElementsByTagName(imageElementLocation);
        textArray.forEach((element) {
          texts.add(element.innerHtml);
        });
        imageArray.forEach((element) {
          images.add(element.attributes['src']);
        });


      
        return [texts, images];
      } catch (e) {
        print(e);
      }
    }
  }
}
