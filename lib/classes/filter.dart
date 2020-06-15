class Filter{
  List removeTextArray;
  Map renameTextMap;

  Filter(this.removeTextArray, this.renameTextMap);

  filter(List textArray, List imageArray){
    Map result = {};
    List<String> filteredTexts = [];
    textArray.forEach((text) {
      if(renameTextMap.keys.contains(text)){
        filteredTexts.add(renameTextMap[text]); // text is renamed to the value found in the rename text map
      }
      else{
        filteredTexts.add(text);
      }
    });
    for(var i = 0; i < textArray.length; i++){
      String text = filteredTexts[i];
      if(!removeTextArray.contains(text)){
        if(text.contains(' ')){
          text = text.replaceAll(' ', '-');
        }
        result[text] = imageArray[i];
      }
    }
    return result;
  }

  addFullLink(String url, List imageLinks){
    List result = [];
    imageLinks.forEach((link) {
      result.add(url + link);
    });
    return result;
  }
}