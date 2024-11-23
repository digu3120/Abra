import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class RepeatBookingInfoWidget extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;
  const RepeatBookingInfoWidget(
      {super.key, required this.bookingDetailsContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ), //boxShadow: shadow),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    '${'booking'.tr} #${bookingDetailsContent.readableId}',
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    width: Dimensions.paddingSizeExtraSmall,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: 12,
                    ),
                  )
                ]),
                BookingStatusButtonWidget(
                  bookingStatus: bookingDetailsContent.bookingStatus,
                )
              ]),
          const SizedBox(
            height: Dimensions.paddingSizeTine,
          ),
          BookingItem(
            img: Images.calendar1,
            title: "${'booking_date'.tr} : ",
            date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                DateConverter.isoUtcStringToLocalDate(
                    bookingDetailsContent.createdAt!)),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeTine,
          ),
          BookingItem(
            img: Images.iconLocation,
            title:
                '${'address'.tr} : ${bookingDetailsContent.serviceAddress != null ? bookingDetailsContent.serviceAddress!.address! : 'no_address_found'.tr}',
            date: '',
          ),
          const SizedBox(
            height: Dimensions.paddingSizeTine,
          ),
        ]),
      ),
    );
  }
}
