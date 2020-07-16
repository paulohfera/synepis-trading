extension ExtendedList on List<String> {
  String joinString([String separator]) {
    if (this == null) return null;
    if (this.isEmpty) return "";

    String message = "";
    String s = "";
    this.forEach((x) {
      message = s + x;
      s = separator;
    });

    return message;
  }
}
