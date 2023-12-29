import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

RegExp imgTagRegex =
RegExp(r'(?<=!\[[^\(]*?\]\().+?(?=[ \)])|(?<=<img src=").+?(?=")');

List<Image> parseReadme(String readME, String baseUrl) {
  List<Image> images = <Image>[];
  Iterable<RegExpMatch> matches = imgTagRegex.allMatches(readME);
  for (final m in matches) {
    String currentImageUrl = m[0]!;
    if (!currentImageUrl.contains("/")) {
      currentImageUrl = baseUrl + currentImageUrl;
    }
    images.add(Image.network(
      currentImageUrl,
      errorBuilder: (context, error, stackTrace) {
        if (error is Exception &&
            error.toString() == "Exception: Invalid image data") {
          return SvgPicture.network(currentImageUrl);
        } else {
          return Text(error.toString());
        }
      },
    ));
  }
  return images;
}
