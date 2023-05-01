extension ToSnakeCase on String {
  String toSnakeCase([String replacement = '_']) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result = this.replaceAllMapped(exp, (Match m) {
      final match = m.group(0) ?? '';
      return replacement + match;
    }).toLowerCase();
    return result;
  }
}
