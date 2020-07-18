List<String> generateKeywords(List<String> keyArrays) {
  final List<String> keywords = [];
  for (final String key in keyArrays) {
    String temp = "";
    key.split("").forEach((String letter) {
      temp += letter;
      keywords.add(temp);
    });
  }
  return keywords;
}
