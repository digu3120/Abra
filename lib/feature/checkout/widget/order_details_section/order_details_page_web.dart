import 'package:demandium/feature/checkout/widget/choose_booking_type_widget.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/repeat_booking_schedule_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class OrderDetailsPageWeb extends StatelessWidget {
  const OrderDetailsPageWeb({super.key}) ;

  @override
  Widget build(BuildContext context) {

    bool isLoggedIn  = Get.find<AuthController>().isLoggedIn();


    return Center( child: SizedBox(width: Dimensions.webMaxWidth,
      child: GetBuilder<ScheduleController>(builder: (scheduleController){
        return GetBuilder<CartController>(builder: (cartController){
          return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(child: WebShadowWrap( minHeight: Get.height * 0.1, child: Column( mainAxisSize: MainAxisSize.min, children: [
              isLoggedIn ? const ChooseBookingTypeWidget() : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              (scheduleController.selectedServiceType == ServiceType.regular || !isLoggedIn) ?
              const ServiceSchedule() : const RepeatBookingScheduleWidget(),

              const SizedBox(height: Dimensions.paddingSizeDefault),
              const AddressInformation(),
              ( cartController.cartList.isNotEmpty && cartController.cartList.first.provider !=null) ?  ProviderDetailsCard(
                providerData: cartController.cartList.first.provider,
              ) : const SizedBox(),

              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Get.find<AuthController>().isLoggedIn() ? const ShowVoucher() : const SizedBox(),

            ]))),

            const SizedBox(width: 30,),
            Expanded(child: WebShadowWrap( minHeight: Get.height * 0.1  ,child: const CartSummery()),),

          ]);
        });
      }),
    ));
  }
}


