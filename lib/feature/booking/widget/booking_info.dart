import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class BookingInfo extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  final BookingDetailsController bookingDetailsTabController;
  const BookingInfo(
      {super.key,
      required this.bookingDetails,
      required this.bookingDetailsTabController,
      required this.isSubBooking});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'booking'.tr} #${bookingDetails.readableId}',
                      style: ubuntuMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
                BookingStatusButtonWidget(
                    bookingStatus: bookingDetails.bookingStatus)
              ]),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
          BookingItem(
            img: Images.calendar1,
            title: "${'booking_date'.tr} : ",
            date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                DateConverter.isoUtcStringToLocalDate(
                    bookingDetails.createdAt!)),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          if (bookingDetails.serviceSchedule != null)
            BookingItem(
              img: Images.calendar1,
              title: "${'service_schedule_date'.tr} : ",
              date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                  DateTime.tryParse(bookingDetails.serviceSchedule!)!),
            ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          BookingItem(
            img: Images.iconLocation,
            title:
                '${'address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'no_address_found'.tr}',
            date: '',
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
          Center(
            child: InkWell(
              onTap: () async {
                Get.dialog(const CustomLoader());
                String languageCode =
                    Get.find<LocalizationController>().locale.languageCode;
                String uri =
                    "${AppConstants.baseUrl}${isSubBooking ? AppConstants.singleRepeatBookingInvoiceUrl : AppConstants.regularBookingInvoiceUrl}${bookingDetails.id}/$languageCode";
                if (kDebugMode) {
                  print("Uri : $uri");
                }
                await _launchUrl(Uri.parse(uri));
                Get.back();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'download'.tr,
                    style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.none),
                  ),
                  Gaps.horizontalGapOf(Dimensions.paddingSizeSmall),
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(Images.downloadImage)),
                ],
              ),
            ),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        ]),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
