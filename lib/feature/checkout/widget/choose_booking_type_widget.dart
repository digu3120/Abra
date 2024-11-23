import 'package:demandium/common/widgets/custom_tooltip_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ChooseBookingTypeWidget extends StatelessWidget {
  const ChooseBookingTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(children: [
          Text(
            "take_the_service".tr,
            style: ubuntuMedium,
          ),
          const SizedBox(
            width: Dimensions.paddingSizeExtraSmall,
          ),
          CustomToolTip(
            message: "take_the_service_hint".tr,
            preferredDirection: AxisDirection.down,
            child: Icon(
              Icons.help_outline_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ),
        ]),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.5),
                width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: kIsWeb ? Dimensions.paddingSizeDefault : 0,
            vertical: kIsWeb ? Dimensions.paddingSizeEight : 2,
          ),
          margin: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Radio<ServiceType>(
                  value: ServiceType.regular,
                  groupValue: scheduleController.selectedServiceType,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    scheduleController.resetScheduleData(shouldUpdate: false);
                    scheduleController.updateSelectedBookingType(
                        type: ServiceType.regular);
                  },
                ),
                Text("only_once".tr),
              ]),
              Row(children: [
                Radio<ServiceType>(
                  value: ServiceType.repeat,
                  groupValue: scheduleController.selectedServiceType,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    scheduleController.resetScheduleData(shouldUpdate: false);
                    scheduleController.updateSelectedBookingType(
                        type: ServiceType.repeat);
                  },
                ),
                Text("multiple_times".tr),
              ]),
              const SizedBox(),
              const SizedBox()
            ],
          ),
        ),
      ]);
    });
  }
}
