import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Network {
  Future getData(String url, String textElementLocation,
      String imageElementLocation) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print('data retrieved');
      List texts = [];
      List images = [];
      try {
        dom.Document document = parser.parse(response.body);
        texts = document.getElementsByTagName(textElementLocation);
        images = document.getElementsByTagName(imageElementLocation);

        return [texts, images];
      } catch (e) {
        print(e);
      }
    }
  }
}
