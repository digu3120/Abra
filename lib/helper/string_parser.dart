class StringParser {

  static String parseString(String mainString, String parseBy) {
    if(mainString.contains("&&") && mainString.contains("=")){
      String urlString = mainString;
      List<String> parts = urlString.split("&&");
      List<String> tokenPart = [];

      for (var element in parts) {
        if(element.contains(parseBy)){
          tokenPart = element.split("$parseBy=");
        }
      }
      if(tokenPart.isNotEmpty){
        return tokenPart.last;
      }else{
        return "";
      }
    }else{
      return "";
    }
  }

  static String obfuscateMiddle(String input) {
    if (input.length <= 7) {
      return input;
    } else {
      String start = input.substring(0, 4);
      String end = input.substring(input.length - 3);
      String middle = '*' * (input.length - 7);
      return '$start$middle$end';
    }
  }
}