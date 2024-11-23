import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ChooseRepeatBookingType extends StatelessWidget {
  const ChooseRepeatBookingType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "booking_type".tr,
        style: ubuntuMedium,
      ),
      const SizedBox(
        height: Dimensions.paddingSizeSmall,
      ),
      GetBuilder<ScheduleController>(builder: (scheduleController) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.5),
                width: 0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: kIsWeb ? 8 : 2),
          child: Row(children: [
            Expanded(
                child: CustomCheckBox(
              title: "daily".tr,
              isTitLeftAlign: false,
              value: scheduleController.selectedRepeatBookingType ==
                  RepeatBookingType.daily,
              onTap: () {
                scheduleController.resetScheduleData(
                    shouldUpdate: false,
                    repeatBookingType: RepeatBookingType.daily);
                scheduleController.updateSelectedRepeatBookingType(
                    type: RepeatBookingType.daily);
              },
            )),
            Expanded(
                child: CustomCheckBox(
              title: "weekly".tr,
              isTitLeftAlign: false,
              value: scheduleController.selectedRepeatBookingType ==
                  RepeatBookingType.weekly,
              onTap: () {
                scheduleController.resetScheduleData(
                    shouldUpdate: false,
                    repeatBookingType: RepeatBookingType.weekly);
                scheduleController.updateSelectedRepeatBookingType(
                    type: RepeatBookingType.weekly);
              },
            )),
            Expanded(
                child: CustomCheckBox(
              title: "custom".tr,
              isTitLeftAlign: false,
              value: scheduleController.selectedRepeatBookingType ==
                  RepeatBookingType.custom,
              onTap: () {
                scheduleController.resetScheduleData(
                    shouldUpdate: false,
                    repeatBookingType: RepeatBookingType.custom);
                scheduleController.updateSelectedRepeatBookingType(
                    type: RepeatBookingType.custom);
              },
            )),
          ]),
        );
      })
    ]);
  }
}
