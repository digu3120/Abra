import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class AllBookingSummaryWidget extends StatelessWidget {
  final TabController? tabController;
  final BookingDetailsContent bookingDetails;
  const AllBookingSummaryWidget({
    super.key,
    this.tabController,
    required this.bookingDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ), //boxShadow: shadow),
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),

      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'all_booking_summary'.tr,
              style: ubuntuMedium.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
            InkWell(
              onTap: () {
                tabController?.index = 1;
              },
              child: Text('view_all_booking'.tr,
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
        ResponsiveHelper.isDesktop(context)
            ? Row(children: [
                Expanded(
                    child: Column(children: [
                  _ItemWidget(
                    title: "booking_type",
                    subtitle: "${bookingDetails.bookingType?.toLowerCase()}".tr,
                  ),
                  _ItemWidget(
                    title: "date_range",
                    subtitle: DateConverter.convertDateTimeRangeToString(
                        DateTimeRange(
                          start: DateTime.tryParse(
                                  bookingDetails.startDate ?? "") ??
                              DateTime.now(),
                          end:
                              DateTime.tryParse(bookingDetails.endDate ?? "") ??
                                  DateTime.now(),
                        ),
                        format: "d MMM, y"),
                  ),
                  _ItemWidget(
                    title: "arrival_time",
                    subtitle: DateConverter.convertDateTimeToTime(
                        DateTime.tryParse(bookingDetails.startDate ?? "") ??
                            DateTime.now()),
                  ),
                  _ItemWidget(
                      title: "total_amount",
                      subtitle: PriceConverter.convertPrice(
                          bookingDetails.totalBookingAmount ?? 0)),
                ])),
                Expanded(
                    child: Column(children: [
                  _ItemWidget(
                      title: "total_booking",
                      subtitle: "${bookingDetails.totalCount ?? ""}"),
                  _ItemWidget(
                      title: "completed",
                      subtitle: "${bookingDetails.completedCount ?? ""}"),
                  _ItemWidget(
                      title: "canceled",
                      subtitle: "${bookingDetails.canceledCount ?? ""}"),
                  _ItemWidget(
                      title: "payment",
                      subtitle: "${bookingDetails.paymentMethod}".tr),
                ]))
              ])
            : Column(children: [
                _ItemWidget(
                  title: "booking_type",
                  subtitle: "${bookingDetails.bookingType?.toLowerCase()}".tr,
                ),
                _ItemWidget(
                  title: "date_range",
                  subtitle: DateConverter.convertDateTimeRangeToString(
                      DateTimeRange(
                        start: DateTime.tryParse(bookingDetails.startDate!) ??
                            DateTime.now(),
                        end: DateTime.tryParse(bookingDetails.endDate!) ??
                            DateTime.now(),
                      ),
                      format: "d MMM, y"),
                ),
                _ItemWidget(
                  title: "arrival_time",
                  subtitle: DateConverter.convertDateTimeToTime(
                      DateTime.tryParse(bookingDetails.startDate!) ??
                          DateTime.now()),
                ),
                _ItemWidget(
                    title: "total_booking",
                    subtitle: "${bookingDetails.totalCount ?? ""}"),
                _ItemWidget(
                    title: "completed",
                    subtitle: "${bookingDetails.completedCount ?? ""}"),
                _ItemWidget(
                    title: "canceled",
                    subtitle: "${bookingDetails.canceledCount ?? ""}"),
                _ItemWidget(
                    title: "total_amount",
                    subtitle: PriceConverter.convertPrice(
                        bookingDetails.totalBookingAmount ?? 0)),
                _ItemWidget(
                    title: "payment",
                    subtitle: "${bookingDetails.paymentMethod}".tr),
              ])
      ]),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ItemWidget({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault, vertical: 3),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Text(
            title.tr,
            style: ubuntuLight,
          ),
        ),
        const Text("    :  "),
        Expanded(
          flex: 4,
          child: Text(
            subtitle,
            style: ubuntuRegular.copyWith(
                height: 1.3, fontSize: Dimensions.fontSizeSmall),
          ),
        ),
      ]),
    );
  }
}
