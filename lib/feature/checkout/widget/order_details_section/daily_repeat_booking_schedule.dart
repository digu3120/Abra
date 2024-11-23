import 'package:demandium/common/widgets/custom_date_range_picker.dart';
import 'package:demandium/common/widgets/custom_time_picker.dart';
import 'package:demandium/common/widgets/custom_tooltip_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class DailyRepeatBookingSchedule extends StatelessWidget {
  const DailyRepeatBookingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        int scheduleDays = CheckoutHelper.calculateDaysCountBetweenDateRange(
            scheduleController.pickedDailyRepeatBookingDateRange);
        int? applicableCouponCount =
            CheckoutHelper.getNumberOfDaysForApplicableCoupon(
          pickedScheduleDays: scheduleDays,
        );

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).hintColor.withOpacity(0.05),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("select_time_and_date".tr, style: ubuntuMedium),
            const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
            Text("daily_select_time_and_date_hint".tr, style: ubuntuLight),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            Row(children: [
              Text(
                "date_range".tr,
                style: ubuntuMedium,
              ),
              const SizedBox(
                width: Dimensions.paddingSizeExtraSmall,
              ),
              CustomToolTip(
                message: "daily_select_time_and_date_hint".tr,
                iconColor: Theme.of(context).colorScheme.primary,
                preferredDirection: AxisDirection.down,
                size: 16,
              ),
            ]),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            CustomDateRangePicker(
              onTimeChanged: (DateTimeRange? dateRange) {
                scheduleController.updateDailyRepeatBookingDateRange =
                    dateRange;
                scheduleController.calculateScheduleCountDays(
                    repeatBookingType: RepeatBookingType.daily);
                scheduleController.update();
              },
              dateTimeRange: scheduleController
                          .pickedDailyRepeatBookingDateRange ==
                      null
                  ? null
                  : DateConverter.convertDateTimeRangeToString(
                      scheduleController.pickedDailyRepeatBookingDateRange!),
              icon: Images.calendar2,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeLarge,
            ),
            Text(
              "arrival_time".tr,
              style: ubuntuMedium,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            CustomTimePicker(
              onTimeChanged: (TimeOfDay? time) {
                scheduleController.updatePickedDailyRepeatTime = time;
                scheduleController.update();
              },
              time: scheduleController.pickedDailyRepeatTime,
            ),
            if (scheduleController.pickedDailyRepeatBookingDateRange != null)
              Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeDefault,
                    bottom: Dimensions.paddingSizeExtraSmall),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                            text: 'you_will_receive_this_services_total'.tr,
                            style: ubuntuLight),
                        TextSpan(
                            text: " $scheduleDays ${'times'.tr}",
                            style: ubuntuBold.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            if (scheduleController.pickedDailyRepeatBookingDateRange != null &&
                applicableCouponCount != null)
              Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeExtraSmall),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                            text: 'coupon_will_be_applied_first'.tr,
                            style: ubuntuLight),
                        TextSpan(
                            text: " $applicableCouponCount ",
                            style: ubuntuBold.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        TextSpan(text: 'services'.tr, style: ubuntuLight),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        );
      });
    });
  }
}
