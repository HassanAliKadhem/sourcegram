import 'package:url_launcher/url_launcher.dart';

Future<void> launchUri(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
