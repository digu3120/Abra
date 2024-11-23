import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderAvailabilityWidget extends StatelessWidget {
  final String providerId;
  const ProviderAvailabilityWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
      initState: (_) {
        Get.find<ProviderBookingController>()
            .getProviderDetailsData(providerId, false);
      },
      builder: (providerBookingController) {
        final daysOfWeek = [
          "saturday",
          "sunday",
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday"
        ];
        final weekends = providerBookingController
                .providerDetailsContent?.provider?.weekends ??
            [];
        List<String> workingDays = [];
        for (var element in daysOfWeek) {
          if (!weekends.contains(element)) {
            workingDays.add(element);
          }
        }
        String? startTime = providerBookingController
            .providerDetailsContent?.provider?.timeSchedule?.startTime;
        String? endTime = providerBookingController
            .providerDetailsContent?.provider?.timeSchedule?.endTime;
        String currentTime =
            DateConverter.convertStringTimeToDate(DateTime.now());
        String dayOfWeek = DateConverter.dateToWeek(DateTime.now());

        bool timeSlotAvailable;
        if (startTime != null && endTime != null) {
          timeSlotAvailable = _isUnderTime(currentTime, startTime, endTime) &&
              (!weekends.contains(dayOfWeek.toLowerCase()));
        } else {
          timeSlotAvailable = false;
        }

        return SizedBox(
          width: Dimensions.webMaxWidth / 2,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(
                  color: Theme.of(context).hintColor.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close, color: Theme.of(context).hintColor),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              (providerBookingController.providerDetailsContent?.provider
                          ?.serviceAvailability ==
                      0)
                  ? Column(
                      children: [
                        Text(
                          'provider_is_currently_unavailable'.tr,
                          style: ubuntuMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall,
                            ),
                            Text(
                              "availability".tr,
                              style: ubuntuMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        ),
                        Text(
                          "unavailability_hint_text".tr,
                          style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Text(
                            "availability".tr,
                            style: ubuntuMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeEight,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: Dimensions.fontSizeDefault,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),
                              Text(
                                timeSlotAvailable
                                    ? "${'today_available_till'.tr} ${DateConverter.convertStringDateTimeToTime(endTime ?? "00:00")}"
                                    : "provider_is_currently_on_a_break".tr,
                                style: ubuntuRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color),
                              ),
                            ],
                          ),
                        ),
                        weekends.length == 7 ||
                                providerBookingController.providerDetailsContent
                                        ?.provider?.timeSchedule ==
                                    null
                            ? const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  workingDays.isNotEmpty
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSeven),
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.1)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge,
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          margin: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeLarge,
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text(
                                                  "usually_available_from".tr,
                                                  style: ubuntuRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.color),
                                                ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall,
                                                ),
                                                if (providerBookingController
                                                        .providerDetailsContent
                                                        ?.provider
                                                        ?.timeSchedule !=
                                                    null)
                                                  Text(
                                                    "${DateConverter.convertStringDateTimeToTime(startTime!)} - ${DateConverter.convertStringDateTimeToTime(endTime!)}",
                                                    style: ubuntuMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault),
                                                  ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                                Text(
                                                  providerBookingController
                                                      .formatDays(workingDays),
                                                  style: ubuntuRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.color),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const Row(),
                                              ]),
                                        )
                                      : const SizedBox(),
                                  weekends.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge),
                                          child: Row(
                                            children: [
                                              Text(
                                                "day_off".tr,
                                                style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color),
                                              ),
                                              const SizedBox(
                                                width:
                                                    Dimensions.paddingSizeEight,
                                              ),
                                              Text(
                                                providerBookingController
                                                    .formatDays(weekends),
                                                style: ubuntuMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                ],
                              ),
                      ],
                    )
            ]),
          ),
        );
      },
    );
  }

  bool _isUnderTime(String time, String startTime, String? endTime) {
    return DateConverter.convertTimeToDateTime(time)
            .isAfter(DateConverter.convertTimeToDateTime(startTime)) &&
        DateConverter.convertTimeToDateTime(time)
            .isBefore(DateConverter.convertTimeToDateTime(endTime!));
  }
}
