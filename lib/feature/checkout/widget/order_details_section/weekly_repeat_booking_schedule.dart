import 'package:demandium/common/widgets/custom_date_range_picker.dart';
import 'package:demandium/common/widgets/custom_time_picker.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class WeeklyRepeatBookingSchedule extends StatelessWidget {
  const WeeklyRepeatBookingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        List<String> weeklyPickedDays =
            scheduleController.getWeeklyPickedDays();

        int scheduleDays = CheckoutHelper
            .calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(
                scheduleController.pickedWeeklyRepeatBookingDateRange,
                weeklyPickedDays);

        int? applicableCouponCount =
            CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                pickedScheduleDays: scheduleDays);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).hintColor.withOpacity(0.05),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "select_time_and_date".tr,
              style: ubuntuMedium,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
            Text("weekly_select_time_and_date_hint".tr,
                style:
                    ubuntuLight.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            Text(
              "select_days".tr,
              style: ubuntuMedium,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            InkWell(
              onTap: () async {
                scheduleController.initWeeklySelectedSchedule();
                if (ResponsiveHelper.isDesktop(context)) {
                  Get.dialog(const _SelectDateWidget());
                } else {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const _SelectDateWidget(),
                  );
                }
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
                  border: Border.all(
                      color: Theme.of(context).hintColor.withOpacity(0.5),
                      width: 0.5),
                ),
                child: Row(children: [
                  weeklyPickedDays.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: weeklyPickedDays.length,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Center(
                                  child: Text(
                                      "${weeklyPickedDays[index].tr}${index != weeklyPickedDays.length - 1 ? "," : ""} "));
                            },
                          ),
                        )
                      : Expanded(
                          child: Text(
                            'select_days'.tr,
                            style: ubuntuRegular.copyWith(
                                color: scheduleController
                                            .pickedDailyRepeatBookingDateRange !=
                                        null
                                    ? null
                                    : Theme.of(context).hintColor),
                            maxLines: 1,
                          ),
                        ),
                  const SizedBox(
                    width: Dimensions.radiusDefault,
                  ),
                  Image.asset(Images.calendar2, width: 17),
                ]),
              ),
            ),
            (scheduleController.pickedWeeklyRepeatBookingDateRange != null &&
                    scheduleController.isFinalRepeatWeeklyBooking)
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeLarge,
                        top: Dimensions.paddingSizeSmall),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                                text: 'every_week_from'.tr, style: ubuntuLight),
                            TextSpan(
                                text:
                                    "  ${DateConverter.dateStringMonthYear(scheduleController.pickedWeeklyRepeatBookingDateRange!.start)}",
                                style: ubuntuBold.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            TextSpan(
                                text: "  ${'to'.tr}  ", style: ubuntuLight),
                            TextSpan(
                                text:
                                    " ${DateConverter.dateStringMonthYear(scheduleController.pickedWeeklyRepeatBookingDateRange!.end)}",
                                style: ubuntuBold.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
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
                scheduleController.updatePickedWeeklyRepeatTime = time;
                scheduleController.update();
              },
              time: scheduleController.pickedWeeklyRepeatTime,
            ),
            if (weeklyPickedDays.isNotEmpty)
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
            if (applicableCouponCount != null && weeklyPickedDays.isNotEmpty)
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
            const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
          ]),
        );
      });
    });
  }
}

class _SelectDateWidget extends StatelessWidget {
  const _SelectDateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height:
            ResponsiveHelper.isDesktop(context) ? Get.height * 0.7 : Get.height,
        width: Dimensions.webMaxWidth / 2.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              ResponsiveHelper.isDesktop(context)
                  ? Dimensions.radiusDefault
                  : 0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GetBuilder<ScheduleController>(builder: (scheduleController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).cardColor,
                borderRadius: BorderRadius.circular(
                    ResponsiveHelper.isDesktop(context)
                        ? Dimensions.radiusDefault
                        : 0),
              ),
              child: Stack(
                children: [
                  Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(children: [
                        const SizedBox(
                          height: Dimensions.paddingSizeDefault * 2,
                        ),
                        Text(
                          "scheduled_days".tr,
                          style: ubuntuMedium,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeTine,
                        ),
                        Text("your_service_booking_date".tr,
                            style: ubuntuLight.copyWith(
                                fontSize: Dimensions.fontSizeSmall)),
                        const SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        ),
                        Divider(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            thickness: 0.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSeven),
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.05),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeSmall,
                                  horizontal: Dimensions.paddingSizeDefault),
                              margin: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeExtraSmall),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 40,
                                  mainAxisSpacing:
                                      Dimensions.paddingSizeExtraSmall,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => scheduleController
                                        .toggleDaysCheckedValue(index),
                                    child: CustomCheckBox(
                                      title: scheduleController.daysList[index],
                                      value: scheduleController
                                          .initialDaysCheckList[index],
                                      onTap: () => scheduleController
                                          .toggleDaysCheckedValue(index),
                                      isTitLeftAlign: false,
                                    ),
                                  );
                                },
                                itemCount: scheduleController.daysList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                            !scheduleController.isInitialRepeatWeeklyBooking
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeDefault),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          TextSpan(
                                              text:
                                                  'you_will_receive_this_services_in_the_upcoming'
                                                      .tr,
                                              style: ubuntuLight),
                                          const TextSpan(text: "\n"),
                                          TextSpan(
                                              text: "week_days".tr,
                                              style: ubuntuBold.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSeven),
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.05),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomCheckBox(
                                      title: "repeat_this_every_week".tr,
                                      value: scheduleController
                                          .isInitialRepeatWeeklyBooking,
                                      isTitLeftAlign: false,
                                      onTap: () {
                                        scheduleController
                                            .updateWeeklyRepeatBookingStatus();
                                      },
                                    ),
                                    scheduleController
                                            .isInitialRepeatWeeklyBooking
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                  "from_to".tr,
                                                  style: ubuntuMedium,
                                                ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall,
                                                ),
                                                Text(
                                                    "select_the_date_range_you_want_to_repeat_this_cycle_every_week"
                                                        .tr,
                                                    style: ubuntuLight.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall)),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                                CustomDateRangePicker(
                                                  icon: Images.calendar2,
                                                  onTimeChanged: (DateTimeRange?
                                                      dateRange) {
                                                    scheduleController
                                                            .updateInitialWeeklyRepeatBookingDateRange =
                                                        dateRange;
                                                    scheduleController.update();
                                                  },
                                                  dateTimeRange: scheduleController
                                                              .initialPickedWeeklyRepeatBookingDateRange ==
                                                          null
                                                      ? null
                                                      : DateConverter
                                                          .convertDateTimeRangeToString(
                                                              scheduleController
                                                                  .initialPickedWeeklyRepeatBookingDateRange!),
                                                ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                              ])
                                        : const SizedBox()
                                  ]),
                            )
                          ]),
                        ),
                      ]),
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: ResponsiveHelper.isDesktop(context)
                              ? null
                              : <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.05), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 3, // Blur radius
                                    offset: const Offset(0,
                                        -4), // Moves the shadow upwards (negative y-offset)
                                  ),
                                ],
                          borderRadius: ResponsiveHelper.isDesktop(context)
                              ? const BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(Dimensions.radiusDefault),
                                  bottomRight:
                                      Radius.circular(Dimensions.radiusDefault))
                              : null),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.paddingSizeDefault
                              : Dimensions.paddingSizeExtraLarge,
                          vertical: 10,
                        ),
                        child: SafeArea(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ResponsiveHelper.isDesktop(context)
                                    ? CustomButton(
                                        backgroundColor: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.2),
                                        textColor: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                        buttonText: "cancel".tr,
                                        onPressed: () => Get.back(),
                                        fontSize: Dimensions.fontSizeSmall + 1,
                                        width: 100,
                                      )
                                    : Expanded(
                                        child: CustomButton(
                                          backgroundColor: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.2),
                                          textColor: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                          buttonText: "cancel".tr,
                                          onPressed: () => Get.back(),
                                        ),
                                      ),
                                const SizedBox(
                                  width: Dimensions.paddingSizeLarge,
                                ),
                                ResponsiveHelper.isDesktop(context)
                                    ? CustomButton(
                                        buttonText: "save".tr,
                                        fontSize: Dimensions.fontSizeSmall + 1,
                                        width: 100,
                                        onPressed: () =>
                                            _onSaveTap(scheduleController),
                                      )
                                    : Expanded(
                                        child: CustomButton(
                                          buttonText: "save".tr,
                                          onPressed: () =>
                                              _onSaveTap(scheduleController),
                                        ),
                                      ),
                              ]),
                        ),
                      ),
                    ),
                  ]),
                  Positioned(
                    right: ResponsiveHelper.isDesktop(context) ? 8 : 15,
                    top: ResponsiveHelper.isDesktop(context) ? 8 : 15,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.2)),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeEight),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  _onSaveTap(ScheduleController scheduleController) {
    if (scheduleController.getInitialWeeklyPickedDays().isEmpty) {
      customSnackBar("select_your_service_booking_date".tr,
          type: ToasterMessageType.info, showDefaultSnackBar: false);
    } else if (scheduleController.isInitialRepeatWeeklyBooking &&
        scheduleController.initialPickedWeeklyRepeatBookingDateRange == null) {
      customSnackBar(
          "select_the_date_range_you_want_to_repeat_this_cycle_every_week".tr,
          type: ToasterMessageType.info,
          showDefaultSnackBar: false);
    } else if (scheduleController.initialPickedWeeklyRepeatBookingDateRange !=
            null &&
        CheckoutHelper
                .calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(
                    scheduleController
                        .initialPickedWeeklyRepeatBookingDateRange,
                    scheduleController.getInitialWeeklyPickedDays()) <=
            0) {
      customSnackBar("no_scheduled_days_available_inside_picked_date_range".tr,
          type: ToasterMessageType.info, showDefaultSnackBar: false);
    } else {
      scheduleController.initWeeklySelectedSchedule(isFirst: false);
      scheduleController.calculateScheduleCountDays(
          repeatBookingType: RepeatBookingType.weekly);
      Get.back();
    }
  }
}
