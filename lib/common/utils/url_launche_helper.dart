import 'package:url_launcher/url_launcher.dart';

class UrlLaucncheHelper {
  static Future<void> openStorePage({required bool isAndroid}) async {
    final Uri url = Uri.parse(
      isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2'
          : 'https://apps.apple.com/app/google-authenticator/id388497605',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open $url';
    }
  }
}
