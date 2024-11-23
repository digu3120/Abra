import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class CustomRepeatBookingScheduleBottomSheet extends StatefulWidget {
  final BookingDetailsContent bookingDetailsContent;
  const CustomRepeatBookingScheduleBottomSheet({
    super.key,
    required this.bookingDetailsContent,
  });

  @override
  State<CustomRepeatBookingScheduleBottomSheet> createState() =>
      _ProductBottomSheetState();
}

class _ProductBottomSheetState
    extends State<CustomRepeatBookingScheduleBottomSheet> {
  @override
  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor() {
    List<RepeatBooking> repeatBookingList =
        widget.bookingDetailsContent.repeatBookingList ?? [];

    return Padding(
      padding: EdgeInsets.only(
          top: ResponsiveHelper.isWeb() ? 0 : Dimensions.cartDialogPadding),
      child: PointerInterceptor(
        child: Container(
            width: ResponsiveHelper.isDesktop(context)
                ? Dimensions.webMaxWidth / 2
                : Dimensions.webMaxWidth,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveHelper.isDesktop(context)
                    ? Dimensions.radiusDefault
                    : Dimensions.radiusExtraLarge),
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                      height: 3,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                              Dimensions.radiusExtraLarge)),
                      margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeLarge),
                    ),
              Text(
                'scheduled_list'.tr,
                style: ubuntuMedium,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                "you_will_receive_your_service_in_the_days_bellow".tr,
                style: ubuntuLight,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: Get.height * 0.1, maxHeight: Get.height * 0.5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: repeatBookingList.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault,
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Dimensions.radiusSeven)),
                      ),
                      margin: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeSmall,
                          left: 10,
                          right: 10),
                      child: GetBuilder<CartController>(
                        builder: (cartController) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateConverter.dateStringMonthYear(
                                      DateTime.tryParse(repeatBookingList[index]
                                          .serviceSchedule!)),
                                  style: ubuntuRegular,
                                ),
                                Row(children: [
                                  Text(
                                    DateConverter.convertDateTimeToTime(
                                        DateTime.now()),
                                    style: ubuntuRegular,
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeSmall,
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    size: 17,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withOpacity(0.6),
                                  )
                                ])
                              ]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ])),
      ),
    );
  }
}
