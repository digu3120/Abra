import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CartSummery extends StatelessWidget {
  const CartSummery({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutController>(builder: (checkoutController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        return GetBuilder<CartController>(builder: (cartController) {
          int scheduleDaysCount = scheduleController.scheduleDaysCount > 0
              ? scheduleController.scheduleDaysCount
              : 1;

          ConfigModel configModel = Get.find<SplashController>().configModel;
          List<CartModel> cartList = cartController.cartList;
          bool walletPaymentStatus = cartController.walletPaymentStatus;
          int applicableCouponCount =
              CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                      pickedScheduleDays: scheduleDaysCount) ??
                  1;
          double additionalCharge = CheckoutHelper.getAdditionalCharge();
          bool isPartialPayment = CheckoutHelper.checkPartialPayment(
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice);
          double paidAmount = CheckoutHelper.calculatePaidAmount(
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice);
          double subTotalPrice = CheckoutHelper.calculateSubTotal(
              cartList: cartList, daysCount: scheduleDaysCount);
          double disCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.general,
              daysCount: scheduleDaysCount);
          double campaignDisCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.campaign,
              daysCount: scheduleDaysCount);
          double couponDisCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.coupon,
              daysCount: applicableCouponCount);
          double referDisCount = cartController.referralAmount;
          double vat = CheckoutHelper.calculateVat(
              cartList: cartList, daysCount: scheduleDaysCount);
          double grandTotal = CheckoutHelper.calculateGrandTotal(
              cartList: cartList,
              referralDiscount: referDisCount,
              daysCount: scheduleDaysCount);
          double dueAmount = CheckoutHelper.calculateDueAmount(
              cartList: cartList,
              walletPaymentStatus: walletPaymentStatus,
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice,
              referralDiscount: referDisCount,
              daysCount: scheduleDaysCount);

          Future.delayed(const Duration(milliseconds: 200), () {
            cartController.updateTotalPrice = grandTotal;
            cartController.update();
          });

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Text('cart_summary'.tr,
                        style: ubuntuMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault))),
                Container(
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Theme.of(context).hoverColor
                          : Theme.of(context).cardColor,
                      boxShadow: Get.isDarkMode ? null : shadow),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      ListView.builder(
                        itemCount: cartList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double totalCost = (cartList
                                      .elementAt(index)
                                      .serviceCost
                                      .toDouble() *
                                  cartList.elementAt(index).quantity) *
                              scheduleDaysCount;
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowText(
                                    title: cartList
                                        .elementAt(index)
                                        .service!
                                        .name!,
                                    quantity:
                                        cartList.elementAt(index).quantity,
                                    price: totalCost),
                                SizedBox(
                                  width: Get.width / 2.5,
                                  child: Text(
                                    cartList.elementAt(index).variantKey,
                                    style: ubuntuMedium.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(.4),
                                        fontSize: Dimensions.fontSizeSmall),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                )
                              ]);
                        },
                      ),
                      Divider(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(.6)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      RowText(title: 'sub_total'.tr, price: subTotalPrice),
                      RowText(title: 'discount'.tr, price: disCount),
                      RowText(
                          title: 'campaign_discount'.tr,
                          price: campaignDisCount),
                      RowText(
                          title: 'coupon_discount'.tr, price: couponDisCount),
                      if (referDisCount > 0)
                        RowText(
                            title: 'referral_discount'.tr,
                            price: referDisCount),
                      RowText(title: 'vat'.tr, price: vat),
                      (configModel.content?.additionalChargeLabelName != "" &&
                              configModel.content?.additionalCharge == 1)
                          ? GetBuilder<CheckOutController>(
                              builder: (controller) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          configModel.content
                                                  ?.additionalChargeLabelName ??
                                              "",
                                          style: ubuntuRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "(+) ${PriceConverter.convertPrice(additionalCharge, isShowLongPrice: true)}",
                                    style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault),
                                  )
                                ],
                              );
                            })
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeSmall),
                        child: Divider(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(.6)),
                      ),
                      RowText(title: 'grand_total'.tr, price: grandTotal),
                      (Get.find<CartController>().walletPaymentStatus)
                          ? RowText(
                              title: 'paid_by_wallet'.tr, price: paidAmount)
                          : const SizedBox(),
                      (Get.find<CartController>().walletPaymentStatus &&
                              isPartialPayment)
                          ? RowText(title: 'due_amount'.tr, price: dueAmount)
                          : const SizedBox(),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeSmall),
                  child: ConditionCheckBox(
                    checkBoxValue: checkoutController.acceptTerms,
                    onTap: (bool? value) {
                      checkoutController.toggleTerms();
                    },
                  ),
                ),
              ]);
        });
      });
    });
  }
}
