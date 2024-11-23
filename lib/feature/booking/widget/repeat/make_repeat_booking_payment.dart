import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class RepeatBookingPaymentDialog extends StatefulWidget {
  final BookingDetailsContent bookingDetails;
  const RepeatBookingPaymentDialog({
    super.key,
    required this.bookingDetails,
  });

  @override
  State<RepeatBookingPaymentDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<RepeatBookingPaymentDialog> {
  @override
  void initState() {
    super.initState();
    Get.find<BookingDetailsController>()
        .updateSelectedDigitalPayment(value: null, shouldUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor() {
    return Padding(
      padding: EdgeInsets.only(
          top: ResponsiveHelper.isWeb() ? 0 : Dimensions.cartDialogPadding),
      child: PointerInterceptor(
        child: Container(
          width: ResponsiveHelper.isDesktop(context)
              ? Dimensions.webMaxWidth / 2
              : Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge)),
          ),
          child: GetBuilder<BookingDetailsController>(
              builder: (bookingDetailsController) {
            List<DigitalPaymentMethod> paymentList =
                Get.find<SplashController>()
                        .configModel
                        .content
                        ?.paymentMethodList ??
                    [];

            return Column(mainAxisSize: MainAxisSize.min, children: [
              ResponsiveHelper.isDesktop(context)
                  ? Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400),
                          padding: const EdgeInsets.all(3),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).hintColor.withOpacity(0.5)),
                      margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeLarge),
                    ),
              Text("${'make_payment'.tr} ",
                  style: ubuntuBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Row(children: [
                Text(" ${'pay_via_online'.tr} ",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
                Expanded(
                    child: Text('faster_and_secure_way_to_pay_bill'.tr,
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor))),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: Get.height * 0.1, maxHeight: Get.height * 0.4),
                child: ListView.builder(
                  itemCount: paymentList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool isSelected = paymentList[index] ==
                        bookingDetailsController.selectedDigitalPaymentMethod;
                    return InkWell(
                      onTap: () {
                        bookingDetailsController.updateSelectedDigitalPayment(
                            value: paymentList[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).hoverColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  height: Dimensions.paddingSizeLarge,
                                  width: Dimensions.paddingSizeLarge,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context).cardColor,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).disabledColor)),
                                  child: Icon(Icons.check,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      size: 16),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeDefault),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  child: CustomImage(
                                    height: Dimensions.paddingSizeLarge,
                                    fit: BoxFit.contain,
                                    image: paymentList[index]
                                            .gatewayImageFullPath ??
                                        "",
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text(
                                  paymentList[index].label ?? "",
                                  style: ubuntuMedium.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ]),
                            ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: CustomButton(
                  buttonText: "pay_now".tr,
                  radius: Dimensions.radiusDefault,
                  onPressed: () {
                    if (bookingDetailsController.selectedDigitalPaymentMethod ==
                        null) {
                      customSnackBar("select_payment_method".tr,
                          type: ToasterMessageType.info,
                          showDefaultSnackBar: false);
                    } else {
                      Get.back();
                      _makePayment(
                          bookingDetailsController
                                  .selectedDigitalPaymentMethod?.gateway ??
                              "",
                          widget.bookingDetails);
                    }
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ]);
          }),
        ),
      ),
    );
  }

  _makePayment(String paymentGateway, BookingDetailsContent bookingDetails) {
    String url = '';
    String hostname = html.window.location.hostname!;
    String protocol = html.window.location.protocol;
    String port = html.window.location.port;
    String? path = html.window.location.pathname;

    String userId = Get.find<UserController>().userInfoModel?.id ?? "";
    String callbackUrl = GetPlatform.isWeb
        ? "$protocol//$hostname:$port$path"
        : AppConstants.baseUrl;
    String platform = GetPlatform.isWeb ? "web" : "app";
    String repeatBookingId = bookingDetails.id ?? "";
    String bookingId = bookingDetails.bookingId ?? "";

    url =
        '${AppConstants.baseUrl}/payment?payment_method=$paymentGateway&access_token=${base64Url.encode(utf8.encode(userId))}'
        '&callback=$callbackUrl&payment_platform=$platform&is_repeat_single_booking=1&booking_repeat_id=$repeatBookingId&booking_id=$bookingId';

    if (GetPlatform.isWeb) {
      printLog("url_with_digital_payment:$url");
      html.window.open(url, "_self");
    } else {
      printLog("url_with_digital_payment_mobile:$url");
      Get.to(() => PaymentScreen(
            url: url,
            fromPage: "repeat-booking",
          ));
    }
  }
}
