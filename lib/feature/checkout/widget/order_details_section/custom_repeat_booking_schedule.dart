import 'package:demandium/common/widgets/custom_time_picker.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/custom_repeat_booking_expansion_tile.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomRepeatBookingSchedule extends StatelessWidget {
  const CustomRepeatBookingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        int scheduleDays =
            scheduleController.pickedCustomRepeatBookingDateTimeList.length;
        int? applicableCouponCount =
            CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                pickedScheduleDays: scheduleDays);

        return Column(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
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
              Text("custom_select_time_and_date_hint".tr,
                  style:
                      ubuntuLight.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
              InkWell(
                onTap: () async {
                  scheduleController.initCustomSelectedSchedule();
                  if (ResponsiveHelper.isDesktop(context)) {
                    Get.dialog(const _SelectDateTimeWidget(),
                        barrierDismissible: true);
                  } else {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => const _SelectDateTimeWidget(),
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
                    Expanded(
                      child: Text(
                        scheduleController.pickedCustomRepeatBookingDateTimeList
                                .isNotEmpty
                            ? "$scheduleDays ${'dates_are_selected'.tr}"
                            : 'pick_date_and_time_for_booking'.tr,
                        style: ubuntuRegular.copyWith(
                            color: scheduleController
                                    .pickedCustomRepeatBookingDateTimeList
                                    .isNotEmpty
                                ? null
                                : Theme.of(context).hintColor),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.radiusDefault,
                    ),
                    Image.asset(Images.calendar3, width: 17),
                  ]),
                ),
              ),
              (scheduleController
                      .pickedCustomRepeatBookingDateTimeList.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(text: 'from'.tr, style: ubuntuLight),
                              TextSpan(
                                  text:
                                      "  ${DateConverter.dateStringMonthYear(DateConverter.convertDateTimeListToDateTimeRange(scheduleController.pickedCustomRepeatBookingDateTimeList)!.start)}",
                                  style: ubuntuBold.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                              TextSpan(
                                  text: "  ${'to'.tr}  ", style: ubuntuLight),
                              TextSpan(
                                  text: DateConverter.dateStringMonthYear(
                                      DateConverter
                                              .convertDateTimeListToDateTimeRange(
                                                  scheduleController
                                                      .pickedCustomRepeatBookingDateTimeList)!
                                          .end),
                                  style: ubuntuBold.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ]),
          ),
          if (scheduleController
              .pickedCustomRepeatBookingDateTimeList.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
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
          scheduleController.pickedCustomRepeatBookingDateTimeList.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
                    color: Theme.of(context).hintColor.withOpacity(0.05),
                  ),
                  margin:
                      const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: CustomRepeatBookingExpansionTile(
                    titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                    text: 'scheduled_list'.tr,
                                    style: ubuntuMedium),
                                TextSpan(
                                    text: " ($scheduleDays)",
                                    style: ubuntuRegular.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                if (applicableCouponCount != null)
                                  const TextSpan(text: '\n'),
                                if (applicableCouponCount != null)
                                  TextSpan(
                                      text:
                                          "${"coupon_will_be_applied_first".tr} $applicableCouponCount ${'services'.tr}",
                                      style: ubuntuLight.copyWith(
                                          fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Divider(
                            height: 1,
                            thickness: 1,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.2)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    child: Text(DateConverter
                                        .dateStringMonthYear(scheduleController
                                                .pickedCustomRepeatBookingDateTimeList[
                                            index])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    child: Text(DateConverter
                                        .convertDateTimeToTime(scheduleController
                                                .pickedCustomRepeatBookingDateTimeList[
                                            index])),
                                  ),
                                  Row(children: [
                                    IconButton(
                                      onPressed: () {
                                        scheduleController
                                            .initCustomSelectedSchedule();
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          builder: (context) =>
                                              _SelectDateTimeWidget(
                                            editIndex: index,
                                          ),
                                        );
                                      },
                                      icon: Image.asset(
                                        Images.edit,
                                        width: 17,
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        scheduleController
                                            .removePickedCustomRepeatBookingDate(
                                                index: index);
                                        scheduleController.update();
                                      },
                                      icon: Image.asset(
                                        Images.cartDeleteVariation,
                                        width: 17,
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ]),
                                ]),
                          );
                        },
                        itemCount: scheduleController
                            .pickedCustomRepeatBookingDateTimeList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ]);
      });
    });
  }
}

class _SelectDateTimeWidget extends StatelessWidget {
  final int? editIndex;
  const _SelectDateTimeWidget({this.editIndex});

  @override
  Widget build(BuildContext context) {
    double width = Dimensions.webMaxWidth / 1.5;

    var dateRangeController = DateRangePickerController();
    return Center(
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? 435 : Get.height,
        width: width,
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
              child: Stack(children: [
                Column(children: [
                  ResponsiveHelper.isDesktop(context)
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Row(children: [
                              SizedBox(
                                  height: 390,
                                  width: width / 2 - 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    child: _CalenderWidget(
                                        scheduleController: scheduleController,
                                        dateRangeController:
                                            dateRangeController,
                                        editIndex: editIndex),
                                  )),
                              SizedBox(
                                  height: 390,
                                  width: width / 2 - 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimensions
                                            .paddingSizeExtraMoreLarge,
                                        bottom:
                                            Dimensions.paddingSizeExtraLarge),
                                    child: _ScheduleListWidget(
                                      scheduleController: scheduleController,
                                      dateRangeController: dateRangeController,
                                      editIndex: editIndex,
                                    ),
                                  )),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault)
                            ]),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              _CalenderWidget(
                                  scheduleController: scheduleController,
                                  dateRangeController: dateRangeController,
                                  editIndex: editIndex),
                              Expanded(
                                  child: _ScheduleListWidget(
                                scheduleController: scheduleController,
                                dateRangeController: dateRangeController,
                                editIndex: editIndex,
                              )),
                            ],
                          ),
                        )),
                  _BottomButtonWidget(scheduleController: scheduleController)
                ]),
                Positioned(
                  right: ResponsiveHelper.isDesktop(context) ? 8 : 15,
                  top: ResponsiveHelper.isDesktop(context) ? 8 : 15,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).hintColor.withOpacity(0.2)),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeEight),
                      child: Icon(
                        Icons.close,
                        size: ResponsiveHelper.isDesktop(context) ? 15 : 18,
                      ),
                    ),
                  ),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

class _CalenderWidget extends StatelessWidget {
  final DateRangePickerController dateRangeController;
  final ScheduleController scheduleController;
  final int? editIndex;
  const _CalenderWidget(
      {required this.scheduleController,
      required this.dateRangeController,
      required this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: Dimensions.paddingSizeDefault,
      ),
      !ResponsiveHelper.isDesktop(context)
          ? Column(children: [
              Text(
                "scheduled_days".tr,
                style: ubuntuMedium,
              ),
              const SizedBox(
                height: Dimensions.paddingSizeTine,
              ),
              Text("your_service_booking_date".tr,
                  style:
                      ubuntuLight.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ])
          : const SizedBox(),
      const SizedBox(
        height: Dimensions.paddingSizeExtraLarge,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(
              color: Theme.of(context).hintColor.withOpacity(0.4), width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeDefault),
        child: SfDateRangePicker(
          controller: dateRangeController,
          backgroundColor: Theme.of(context).cardColor,
          showNavigationArrow: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value != null) {
              List<DateTime> oldList = scheduleController
                  .pickedInitialCustomRepeatBookingDateTimeList;
              List<DateTime> newList = List<DateTime>.from(args.value);

              Map<String, DateTime?> result = traceDateChange(oldList, newList);
              TimeOfDay initialPickedTime = oldList.isNotEmpty
                  ? DateConverter.convertDateTimeToTimeOfDay(oldList.first)
                  : TimeOfDay.now();

              if (result['added'] != null) {
                DateTime date = result['added']!;
                scheduleController.pickedInitialCustomRepeatBookingDateTimeList
                    .add(DateConverter.combineDateTimeAndTimeOfDay(
                        date: date, time: initialPickedTime));
              }
              if (result['removed'] != null) {
                DateTime date = result['removed']!;
                scheduleController.pickedInitialCustomRepeatBookingDateTimeList
                    .remove(DateConverter.combineDateTimeAndTimeOfDay(
                        date: date, time: initialPickedTime));
              }
              scheduleController.update();
            }
          },
          initialSelectedDates:
              scheduleController.pickedCustomRepeatBookingDateTimeList,
          selectionMode: DateRangePickerSelectionMode.multiple,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          viewSpacing: 10,
          headerHeight: 50,
          toggleDaySelection: true,
          enablePastDates: false,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
            textAlign: TextAlign.center,
            textStyle: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _ScheduleListWidget extends StatelessWidget {
  final DateRangePickerController dateRangeController;
  final ScheduleController scheduleController;
  final int? editIndex;
  const _ScheduleListWidget(
      {required this.scheduleController,
      required this.dateRangeController,
      this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: Dimensions.paddingSizeDefault),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.4),
                width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraSmall,
              horizontal: Dimensions.paddingSizeDefault),
          child: Column(children: [
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            Text(
              "scheduled_list".tr,
              style: ubuntuMedium,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            scheduleController
                    .pickedInitialCustomRepeatBookingDateTimeList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (kDebugMode) {
                          print("Edited Index : $editIndex");
                        }
                        return editIndex == index
                            ? CustomShakingWidget(
                                shakeCount: 2,
                                shakeOffset: 5,
                                child: scheduleItem(context, scheduleController,
                                    index, dateRangeController),
                              )
                            : scheduleItem(context, scheduleController, index,
                                dateRangeController);
                      },
                      itemCount: scheduleController
                          .pickedInitialCustomRepeatBookingDateTimeList.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                    ),
                  )
                : Text(
                    'no_schedule_date_picked'.tr,
                    style: ubuntuLight.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                  ),
            const Row(),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
          ]),
        ),
      )
    ]);
  }

  Container scheduleItem(
      BuildContext context,
      ScheduleController scheduleController,
      int index,
      DateRangePickerController dateRangeController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).hintColor.withOpacity(0.05),
      ),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Text(
            DateConverter.dateStringMonthYear(scheduleController
                .pickedInitialCustomRepeatBookingDateTimeList[index]),
            style: ubuntuRegular,
          ),
        ),
        CustomTimePicker(
          onTimeChanged: (TimeOfDay time) {
            DateTime dateTime = DateConverter.combineDateTimeAndTimeOfDay(
              date: scheduleController
                  .pickedInitialCustomRepeatBookingDateTimeList[index],
              time: time,
            );

            scheduleController.updateCustomRepeatBookingDateTime(
                index: index, dateTime: dateTime);
          },
          isExpandedRow: false,
          time: DateConverter.convertDateTimeToTimeOfDay(scheduleController
              .pickedInitialCustomRepeatBookingDateTimeList[index]),
        ),
        IconButton(
          onPressed: () {
            scheduleController.removeInitialPickedCustomRepeatBookingDate(
                index: index);
            dateRangeController.selectedDates =
                scheduleController.pickedInitialCustomRepeatBookingDateTimeList;
            scheduleController.update();
          },
          icon: Icon(
            Icons.cancel_outlined,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
        ),
      ]),
    );
  }
}

class _BottomButtonWidget extends StatelessWidget {
  final ScheduleController scheduleController;
  const _BottomButtonWidget({required this.scheduleController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Shadow color
                    spreadRadius: 1, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(
                        0, -4), // Moves the shadow upwards (negative y-offset)
                  ),
                ],
          borderRadius: ResponsiveHelper.isDesktop(context)
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusDefault),
                  bottomRight: Radius.circular(Dimensions.radiusDefault))
              : null),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context)
              ? Dimensions.paddingSizeDefault
              : Dimensions.paddingSizeExtraLarge,
          vertical: 10,
        ),
        child: SafeArea(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ResponsiveHelper.isDesktop(context)
                ? CustomButton(
                    backgroundColor:
                        Theme.of(context).hintColor.withOpacity(0.2),
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    buttonText: "cancel".tr,
                    onPressed: () => Get.back(),
                    fontSize: Dimensions.fontSizeSmall + 1,
                    width: 100,
                  )
                : Expanded(
                    child: CustomButton(
                      backgroundColor:
                          Theme.of(context).hintColor.withOpacity(0.2),
                      textColor: Theme.of(context).textTheme.bodyLarge?.color,
                      buttonText: "cancel".tr,
                      onPressed: () => Get.back(),
                      width: double.infinity,
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
                    onPressed: _onSaveTap,
                  )
                : Expanded(
                    child: CustomButton(
                      buttonText: "save".tr,
                      onPressed: _onSaveTap,
                    ),
                  )
          ]),
        ),
      ),
    );
  }

  _onSaveTap() {
    if (scheduleController
        .pickedInitialCustomRepeatBookingDateTimeList.isEmpty) {
      customSnackBar("select_your_service_booking_date".tr,
          type: ToasterMessageType.info, showDefaultSnackBar: false);
    } else {
      scheduleController.initCustomSelectedSchedule(isFirst: false);
      scheduleController.calculateScheduleCountDays(
          repeatBookingType: RepeatBookingType.custom);
      Get.back();
    }
  }
}

Map<String, DateTime?> traceDateChange(
    List<DateTime> oldList, List<DateTime> newList) {
  Set<String> oldSet = oldList.map((date) => _dateToDayString(date)).toSet();
  Set<String> newSet = newList.map((date) => _dateToDayString(date)).toSet();

  DateTime? addedDate = newSet.difference(oldSet).isNotEmpty
      ? DateTime.parse(newSet.difference(oldSet).first)
      : null;

  DateTime? removedDate = oldSet.difference(newSet).isNotEmpty
      ? DateTime.parse(oldSet.difference(newSet).first)
      : null;
  return {
    'added': addedDate,
    'removed': removedDate,
  };
}

String _dateToDayString(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
