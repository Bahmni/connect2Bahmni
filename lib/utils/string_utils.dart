String truncate(String text, [ length = 30, replacement = '...' ]) {
  if (length >= text.length) {
    return text;
  }
  return text.replaceRange(length, text.length, replacement);
}