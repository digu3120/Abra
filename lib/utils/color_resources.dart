import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ColorResources {

  static Color getRightBubbleColor() {
    return  Theme.of(Get.context!).primaryColor;
  }
  static Color getLeftBubbleColor() {
    return Get.isDarkMode ? const Color(0xA2B7B7BB): Theme.of(Get.context!).primaryColor.withOpacity(0.08);
  }

  static const Map<String, Color> buttonBackgroundColorMap ={
    'pending': Color(0x457bc2f6),
    'accepted': Color(0x499ad0fb),
    'ongoing': Color(0x629ac5f8),
    'completed': Color(0x5faff4c1),
    'settled': Color(0x6e93b347),
    'canceled': Color(0x51F6A9A9),
    'approved': Color(0x80356e4c),
    'expired' : Color(0x8C7C3B3B),
    'running' : Color(0x793c4fd8),
    'denied':  Color(0x666e3737),
    'paused': Color(0xff0461A5),
    'resumed' : Color(0x6f2f5e41),
    'resume' : Color(0x8e387c54),
    'subscription_purchase' : Color(0x3cecc98d),
    'subscription_renew' : Color(0x1d6bf5a2),
    'subscription_shift' : Color(0x452599ee),
    'subscription_refund' : Color(0x1dc97eee),
  };

  static const Map<String, Color> buttonTextColorMap ={
    'pending': Color(0xff058df3),
    'accepted': Color(0xff2B95FF),
    'ongoing': Color(0xff2B95FF),
    'completed': Color(0xff03b158),
    'settled': Color(0xf57b9826),
    'canceled': Color(0xfff44747),
    'approved': Color(0xff16B559),
    'expired' : Color(0xff9ca8af),
    'running' : Color(0xff707ec6),
    'denied':  Color(0xffFF3737),
    'paused': Color(0xff0461A5),
    'resumed' : Color(0xff16B559),
    'resume' : Color(0xff16B559),
    'subscription_purchase' : Color(0xffe7680a),
    'subscription_renew' : Color(0xff16B559),
    'subscription_shift' : Color(0xff0461A5),
    'subscription_refund' : Color(0xffba4af8),
  };
}