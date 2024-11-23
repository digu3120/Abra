import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class NotificationIgnoredBottomSheet extends StatelessWidget {
  final String? bookingId;

  const NotificationIgnoredBottomSheet({super.key, this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
            top: const Radius.circular(Dimensions.radiusLarge),
            bottom: Radius.circular(ResponsiveHelper.isDesktop(context)
                ? Dimensions.radiusLarge
                : 0)),
        boxShadow: cardShadow,
      ),
      child: SizedBox(
          width: Dimensions.webMaxWidth / 2.5,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ResponsiveHelper.isDesktop(context)
                ? InkWell(
                    onTap: () => Get.back(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child:
                          Icon(Icons.close, color: Theme.of(context).hintColor),
                    ),
                  )
                : Center(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeDefault,
                          bottom: Dimensions.paddingSizeEight),
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeExtraSmall)),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeDefault,
                  horizontal: Dimensions.paddingSizeSmall),
              child: Image.asset(Images.providerUnavailable, width: 60),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'booking_ignored_title'.tr,
                textAlign: TextAlign.center,
                style: ubuntuMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                "booking_ignored_description".tr,
                style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            ResponsiveHelper.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                        Expanded(
                            child: TextButton(
                          onPressed: () {
                            Get.back();
                            Get.find<BookingDetailsController>()
                                .bookingCancel(bookingId: bookingId ?? "");
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(Get.context!)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            minimumSize: const Size(Dimensions.webMaxWidth, 45),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall)),
                          ),
                          child: Text(
                            "cancel_booking".tr,
                            textAlign: TextAlign.center,
                            style: ubuntuMedium.copyWith(
                              color: Theme.of(Get.context!)
                                  .textTheme
                                  .bodySmall
                                  ?.color,
                              fontSize: Dimensions.paddingSizeSmall + 1,
                            ),
                          ),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                        Expanded(
                          child: CustomButton(
                            backgroundColor:
                                Theme.of(Get.context!).colorScheme.primary,
                            textColor: Colors.white,
                            buttonText:
                                "${'let'.tr} ${AppConstants.appName} ${'choose'.tr}",
                            onPressed: () {
                              Get.back();
                              customSnackBar(
                                  "${'thanks_for_choosing'.tr} ${AppConstants.appName}",
                                  type: ToasterMessageType.success);
                            },
                            radius: Dimensions.radiusSmall,
                            height: 45,
                            fontSize: Dimensions.paddingSizeSmall + 1,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                      ])
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      CustomButton(
                        backgroundColor:
                            Theme.of(Get.context!).colorScheme.primary,
                        textColor: Colors.white,
                        buttonText:
                            "${'let'.tr} ${AppConstants.appName} ${'choose'.tr}",
                        onPressed: () {
                          Get.back();
                          customSnackBar(
                              "${'thanks_for_choosing'.tr} ${AppConstants.appName}",
                              type: ToasterMessageType.success);
                        },
                        radius: Dimensions.radiusSmall,
                        height: 45,
                        fontSize: Dimensions.paddingSizeSmall + 1,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.find<BookingDetailsController>()
                              .bookingCancel(bookingId: bookingId ?? "");
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(Get.context!)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          minimumSize: const Size(Dimensions.webMaxWidth, 45),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall)),
                        ),
                        child: Text(
                          "cancel_booking".tr,
                          textAlign: TextAlign.center,
                          style: ubuntuMedium.copyWith(
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodySmall
                                ?.color,
                            fontSize: Dimensions.paddingSizeSmall + 1,
                          ),
                        ),
                      ),
                    ]),
                  ),
            if (ResponsiveHelper.isDesktop(context))
              const SizedBox(
                height: Dimensions.paddingSizeLarge,
              )
          ])),
    );
  }
}
