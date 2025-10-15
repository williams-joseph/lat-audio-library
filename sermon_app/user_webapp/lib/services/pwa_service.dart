// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class PwaService {
  static bool get canInstall {
    return js.context.hasProperty('beforeinstallprompt');
  }
  
  static Future<bool> showInstallPrompt() async {
    try {
      // This will trigger the browser's native install prompt
      final result = js.context.callMethod('showInstallPrompt');
      return result == 'accepted';
    } catch (e) {
      return false;
    }
  }
}