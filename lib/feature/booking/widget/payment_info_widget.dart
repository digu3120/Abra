import 'package:demandium/feature/booking/widget/repeat/make_repeat_booking_payment.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class PaymentView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  const PaymentView(
      {super.key, required this.bookingDetails, required this.isSubBooking});

  @override
  Widget build(BuildContext context) {
    return isSubBooking &&
            bookingDetails.isPaid == 0 &&
            (bookingDetails.bookingStatus == "ongoing" ||
                bookingDetails.bookingStatus == "accepted")
        ? _MakePaymentView(bookingDetails, isSubBooking)
        : _PaidPaymentView(bookingDetails, isSubBooking);
  }
}

class _PaidPaymentView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  const _PaidPaymentView(this.bookingDetails, this.isSubBooking);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ), //boxShadow: shadow),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('payment_method'.tr,
              style: ubuntuBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                decoration: TextDecoration.none,
              )),
          const SizedBox(height: Dimensions.radiusDefault),
          Text(bookingDetails.paymentMethod!.tr,
              style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6)),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: Dimensions.radiusDefault),
          Text('${'transaction_id'.tr} : ${bookingDetails.transactionId ?? ''}',
              style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6)),
              overflow: TextOverflow.ellipsis),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${bookingDetails.isPaid == 0 ? 'unpaid'.tr : 'paid'.tr} ',
              style: ubuntuMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: bookingDetails.isPaid == 0
                      ? Theme.of(context).colorScheme.error
                      : Colors.green,
                  decoration: TextDecoration.none)),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
                PriceConverter.convertPrice(
                    bookingDetails.totalBookingAmount!.toDouble(),
                    isShowLongPrice: true),
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
        ]),
      ]),
    );
  }
}

class _MakePaymentView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  const _MakePaymentView(this.bookingDetails, this.isSubBooking);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ), //boxShadow: shadow),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: ResponsiveHelper.isDesktop(context) ? 4 : 3,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text("${"total_amount".tr} :  ", style: ubuntuLight),
              Text(
                PriceConverter.convertPrice(
                    bookingDetails.totalBookingAmount ?? 0),
                style: ubuntuMedium,
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeTine),
            Row(children: [
              Text("${"payment_status".tr} :  ", style: ubuntuLight),
              Text(
                bookingDetails.isPaid == 1 ? "paid".tr : "unpaid".tr,
                style: ubuntuMedium.copyWith(
                    color: bookingDetails.isPaid == 1
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                    fontSize: Dimensions.fontSizeSmall + 1),
              ),
            ]),
          ]),
        ),
        Expanded(
          flex: 2,
          child: CustomButton(
            buttonText: "make_payment".tr,
            fontSize: Dimensions.fontSizeDefault,
            height: 40,
            onPressed: () {
              if (ResponsiveHelper.isDesktop(context)) {
                Get.dialog(
                    RepeatBookingPaymentDialog(bookingDetails: bookingDetails));
              } else {
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => RepeatBookingPaymentDialog(
                        bookingDetails: bookingDetails));
              }
            },
          ),
        ),
      ]),
    );
  }
}
