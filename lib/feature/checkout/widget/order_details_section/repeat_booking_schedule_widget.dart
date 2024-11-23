import 'package:demandium/feature/checkout/widget/order_details_section/choose_repeat_booking_type.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/custom_repeat_booking_schedule.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/daily_repeat_booking_schedule.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/weekly_repeat_booking_schedule.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class RepeatBookingScheduleWidget extends StatelessWidget {
  const RepeatBookingScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ScheduleController>(builder: (scheduleController){
      return  Column(children: [
        const ChooseRepeatBookingType(),
        const SizedBox(height: Dimensions.paddingSizeLarge,),

        scheduleController.selectedRepeatBookingType == RepeatBookingType.daily ? const DailyRepeatBookingSchedule()
            : scheduleController.selectedRepeatBookingType == RepeatBookingType.weekly ? const WeeklyRepeatBookingSchedule()
            : const CustomRepeatBookingSchedule()

      ]);
    });
  }
}
