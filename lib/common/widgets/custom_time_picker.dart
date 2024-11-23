import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimeChanged;
  final bool isExpandedRow;
  const CustomTimePicker(
      {super.key,
      this.time,
      required this.onTimeChanged,
      this.isExpandedRow = true});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: () async {
          TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: DateTime.now().hour, minute: DateTime.now().minute),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: Get.find<SplashController>()
                          .configModel
                          .content
                          ?.timeFormat ==
                      "24",
                ),
                child: child!,
              );
            },
          );
          if (time != null) {
            onTimeChanged(time);
          }
        },
        child: Container(
          height: isExpandedRow ? 50 : 35,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: isExpandedRow
                  ? Dimensions.paddingSizeDefault
                  : Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.5),
                width: 0.5),
          ),
          child: Row(children: [
            Text(
              time != null
                  ? DateConverter.convertDateTimeToTime(DateTime(
                      DateTime.now().year, 1, 1, time!.hour, time!.minute))
                  : 'time_hint'.tr,
              style: ubuntuRegular.copyWith(
                  color: time != null ? null : Theme.of(context).hintColor),
              maxLines: 1,
            ),
            isExpandedRow
                ? const Expanded(child: SizedBox())
                : const SizedBox(
                    width: Dimensions.paddingSizeSmall,
                  ),
            Icon(Icons.access_time,
                size: 20,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.5)),
          ]),
        ),
      ),
    ]);
  }
}
