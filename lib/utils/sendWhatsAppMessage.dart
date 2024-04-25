import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'package:url_launcher/url_launcher.dart';

void sendWhatsAppMessage(String message, String phone) async {
  final link = WhatsAppUnilink(
    phoneNumber: phone,
    text: message,
  );
  await launchUrl(link.asUri());
}
