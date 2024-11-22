import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

void customSnackBar(String? message, {ToasterMessageType type = ToasterMessageType.error, double margin = Dimensions.paddingSizeSmall,int duration =2, Color? backgroundColor, Widget? customWidget, double borderRadius = Dimensions.radiusSmall, bool showDefaultSnackBar = true}) {
  if(message != null && message.isNotEmpty) {

    if(showDefaultSnackBar){
      final width = MediaQuery.of(Get.context!).size.width;
      ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
        content:  Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF334257),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
             // margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: customWidget ?? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon( type == ToasterMessageType.error ? CupertinoIcons.multiply_circle_fill : type == ToasterMessageType.info ?  Icons.info  : Icons.check_circle,
                  color: type == ToasterMessageType.info  ?  Colors.blueAccent : type == ToasterMessageType.error? const Color(0xffFF9090).withOpacity(0.5) : const Color(0xff039D55),
                  size: 20,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Flexible(child: Text(message, style: ubuntuRegular.copyWith(color : Colors.white.withOpacity(0.8)), maxLines: 3, overflow: TextOverflow.ellipsis)),
              ]),
            ),
          ),
        ),
        padding: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(Get.context) ? Dimensions.paddingSizeLarge : 0),
        margin: ResponsiveHelper.isDesktop(Get.context!)
            ? EdgeInsets.only(left: width * 0.7, bottom: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall)
            : const EdgeInsets.symmetric( horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: 0,
      ));

    }else{
      Get.showSnackbar(GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: duration),
        overlayBlur: 0.0,
        messageText: customWidget ?? Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF334257),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon( type == ToasterMessageType.error ? CupertinoIcons.multiply_circle_fill : type == ToasterMessageType.info ?  Icons.info  : Icons.check_circle,
                  color: type == ToasterMessageType.info  ?  Colors.blueAccent : type == ToasterMessageType.error? const Color(0xffFF9090).withOpacity(0.5) : const Color(0xff039D55),
                  size: 20,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Flexible(child: Text(message, style: ubuntuRegular.copyWith(color : Colors.white.withOpacity(0.8)), maxLines: 3, overflow: TextOverflow.ellipsis)),
              ]),
            ),
          ),
        ),
        maxWidth: Dimensions.webMaxWidth,
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.only(
            top: Dimensions.paddingSizeSmall,
            left: ResponsiveHelper.isDesktop(Get.context) ? Dimensions.webMaxWidth/2: Dimensions.paddingSizeSmall,
            right: ResponsiveHelper.isDesktop(Get.context) ? (Get.width-Dimensions.webMaxWidth)/2: Dimensions.paddingSizeSmall,
            bottom: margin),
        borderRadius: borderRadius,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      ));
    }
  }
}
