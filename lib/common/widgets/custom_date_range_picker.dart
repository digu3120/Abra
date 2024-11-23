import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTimeRange?) onTimeChanged;
  final String? dateTimeRange;
  final String? icon;
  const CustomDateRangePicker(
      {super.key, required this.onTimeChanged, this.dateTimeRange, this.icon});

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  var dateRangeController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Get.dialog(
          DateRangeWidget(
            onTimeChanged: (PickerDateRange? dateRange) {
              if (dateRange != null) {
                widget.onTimeChanged(
                  DateTimeRange(
                      start: dateRange.startDate ?? DateTime.now(),
                      end: dateRange.endDate ?? DateTime.now()),
                );
              }
            },
            dateRangeController: dateRangeController,
          ),
        );
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
                width: 0.5)),
        child: Row(children: [
          Text(
            widget.dateTimeRange ?? 'date_range_hint'.tr,
            style: ubuntuRegular.copyWith(
                color: widget.dateTimeRange != null
                    ? null
                    : Theme.of(context).hintColor),
            maxLines: 1,
          ),
          const Expanded(child: SizedBox()),
          Image.asset(widget.icon ?? Images.calendar1, width: 17),
        ]),
      ),
    );
  }
}

class DateRangeWidget extends StatelessWidget {
  final Function(PickerDateRange?) onTimeChanged;
  final DateRangePickerController dateRangeController;
  final PickerDateRange? dateTimeRange;
  const DateRangeWidget(
      {super.key,
      required this.onTimeChanged,
      required this.dateRangeController,
      this.dateTimeRange});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.4),
                width: 0.5),
            color: Theme.of(context).cardColor),
        width: Dimensions.webMaxWidth / 2.5,
        margin:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("select_date_range".tr,
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          SizedBox(
            height: 320,
            child: SfDateRangePicker(
              controller: dateRangeController,
              backgroundColor: Theme.of(context).cardColor,
              showNavigationArrow: true,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value != null) {
                  dateRangeController.selectedRange = args.value;
                }
              },
              initialSelectedRange: dateTimeRange,
              selectionMode: DateRangePickerSelectionMode.range,
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
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(children: [
            Expanded(
              child: CustomButton(
                buttonText: "cancel".tr,
                radius: Dimensions.radiusDefault,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
                backgroundColor: Theme.of(context).hintColor.withOpacity(0.2),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomButton(
                radius: Dimensions.radiusDefault,
                buttonText: "save".tr,
                onPressed: () {
                  if (dateRangeController.selectedRange == null ||
                      dateRangeController.selectedRange?.startDate == null ||
                      dateRangeController.selectedRange?.endDate == null) {
                    customSnackBar("select_date_range".tr,
                        type: ToasterMessageType.info,
                        showDefaultSnackBar: false);
                  } else {
                    onTimeChanged(dateRangeController.selectedRange);
                    Get.back();
                  }
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ])
        ]),
      ),
    );
  }
}
