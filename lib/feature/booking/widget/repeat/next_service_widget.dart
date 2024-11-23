import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NextServiceWidget extends StatelessWidget {
  final RepeatBooking booking;
  const NextServiceWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ),
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              booking.bookingStatus == "accepted"
                  ? 'next_service'.tr
                  : "ongoing_service".tr,
              style: ubuntuMedium.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.getBookingDetailsScreen(
                    subBookingId: booking.id!));
              },
              child: Text('view_details'.tr,
                  style: ubuntuBold.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
            )
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).hintColor.withOpacity(0.4),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'ID # ${booking.readableId ?? ""}',
                style: ubuntuMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontSize: Dimensions.fontSizeSmall + 1,
                ),
              ),
              Text(PriceConverter.convertPrice(booking.totalBookingAmount ?? 0),
                  style: ubuntuMedium),
            ]),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              BookingStatusButtonWidget(
                bookingStatus: booking.bookingStatus,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("${"payment_status".tr} :  ", style: ubuntuLight),
                Text(
                  booking.isPaid == 1 ? "paid".tr : "unpaid".tr,
                  style: ubuntuMedium.copyWith(
                      color: booking.isPaid == 1
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                      fontSize: Dimensions.fontSizeSmall + 1),
                ),
              ]),
            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            DottedBorder(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              dashPattern: const [4, 2],
              strokeWidth: 1.1,
              borderType: BorderType.RRect,
              padding: EdgeInsets.zero,
              radius: const Radius.circular(Dimensions.radiusDefault),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.05)),
                  child: Column(children: [
                    const Row(),
                    Text("scheduled_at".tr, style: ubuntuRegular),
                    const SizedBox(height: Dimensions.paddingSizeEight),
                    Text(
                      DateConverter.dateMonthYearTime(
                              DateTime.tryParse(booking.serviceSchedule!))
                          .tr,
                      style: ubuntuLight,
                    ),
                  ])),
            ),
          ]),
        ),
      ]),
    );
  }
}
