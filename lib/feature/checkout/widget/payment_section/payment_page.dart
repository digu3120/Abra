import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final JustTheController tooltipController;
  final String fromPage;
  const PaymentPage(
      {super.key,
      required this.addressId,
      required this.tooltipController,
      required this.fromPage});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    Get.find<CheckOutController>().showOfflinePaymentInputDialog("checkout");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<CheckOutController>(builder: (checkoutController) {
        return GetBuilder<CartController>(builder: (cartController) {
          double walletBalance = cartController.walletBalance;
          double bookingAmount = widget.fromPage == "custom-checkout"
              ? checkoutController.totalAmount
              : cartController.totalPrice;
          bool walletPaymentStatus = cartController.walletPaymentStatus;
          bool isPartialPayment = CheckoutHelper.checkPartialPayment(
              walletBalance: walletBalance, bookingAmount: bookingAmount);
          bool hidePaymentMethod = walletPaymentStatus && !isPartialPayment;
          bool isRepeatBooking =
              Get.find<ScheduleController>().selectedServiceType ==
                  ServiceType.repeat;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault),
            child: (checkoutController.othersPaymentList.isEmpty &&
                    checkoutController.digitalPaymentList.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeLarge * 2),
                    child: Text("no_payment_method_available".tr,
                        style: ubuntuMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).colorScheme.error)),
                  )
                : isRepeatBooking
                    ? const _RepeatBookingCashPaymentCard()
                    : Column(children: [
                        if (checkoutController.othersPaymentList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              Text(" ${'choose_payment_method'.tr} ",
                                  style: ubuntuBold.copyWith(
                                      fontSize: Dimensions.fontSizeDefault)),
                              Expanded(
                                  child: Text(
                                      'click_one_of_the_option_bellow'.tr,
                                      style: ubuntuLight.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeSmall - 2,
                                          color: Theme.of(context).hintColor))),
                            ]),
                          ),
                        (checkoutController.othersPaymentList.isNotEmpty) &&
                                ResponsiveHelper.isDesktop(context)
                            ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            cartController.walletPaymentStatus
                                                ? 1
                                                : 2,
                                        mainAxisExtent: cartController
                                                    .walletPaymentStatus &&
                                                isPartialPayment
                                            ? Get.find<LocalizationController>()
                                                    .isLtr
                                                ? 110
                                                : 100
                                            : 90,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount:
                                    checkoutController.othersPaymentList.length,
                                itemBuilder: (ctx, index) {
                                  return PaymentMethodButton(
                                    title: checkoutController
                                        .othersPaymentList[index].title,
                                    paymentMethodName: checkoutController
                                        .othersPaymentList[index]
                                        .paymentMethodName,
                                    assetName: checkoutController
                                        .othersPaymentList[index].assetName,
                                    hidePaymentMethod: hidePaymentMethod,
                                    itemHeight: 75,
                                    walletBalance: walletBalance,
                                    bookingAmount: bookingAmount,
                                  );
                                },
                              )
                            : (checkoutController.othersPaymentList.isNotEmpty)
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: checkoutController
                                        .othersPaymentList.length,
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                Dimensions.paddingSizeDefault),
                                        child: PaymentMethodButton(
                                          title: checkoutController
                                              .othersPaymentList[index].title,
                                          paymentMethodName: checkoutController
                                              .othersPaymentList[index]
                                              .paymentMethodName,
                                          assetName: checkoutController
                                              .othersPaymentList[index]
                                              .assetName,
                                          hidePaymentMethod: hidePaymentMethod,
                                          walletBalance: walletBalance,
                                          bookingAmount: bookingAmount,
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Stack(children: [
                          Opacity(
                            opacity: hidePaymentMethod ? 0.5 : 1,
                            child: Column(children: [
                              if (checkoutController
                                  .digitalPaymentList.isNotEmpty)
                                Row(children: [
                                  Text(" ${'pay_via_online'.tr} ",
                                      style: ubuntuBold.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeDefault)),
                                  Expanded(
                                      child: Text(
                                          'faster_and_secure_way_to_pay_bill'
                                              .tr,
                                          style: ubuntuLight.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall - 2,
                                              color: Theme.of(context)
                                                  .hintColor))),
                                ]),
                              if (checkoutController
                                  .digitalPaymentList.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.paddingSizeDefault),
                                  child: DigitalPaymentMethodView(
                                    paymentList:
                                        checkoutController.digitalPaymentList,
                                    onTap: (index) =>
                                        checkoutController.changePaymentMethod(
                                            digitalMethod: checkoutController
                                                .digitalPaymentList[index]),
                                    tooltipController: widget.tooltipController,
                                    fromPage: widget.fromPage,
                                  ),
                                ),
                            ]),
                          ),
                          if (hidePaymentMethod)
                            Positioned.fill(
                                child: Container(
                              color: Colors.transparent,
                            )),
                        ])
                      ]),
          );
        });
      }),
    );
  }
}

class _RepeatBookingCashPaymentCard extends StatelessWidget {
  const _RepeatBookingCashPaymentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
        boxShadow: searchBoxShadow,
      ),
      width: ResponsiveHelper.isDesktop(context) ? 350 : 270,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: EdgeInsets.only(
          top: ResponsiveHelper.isDesktop(context) ? 10 : 0,
          bottom: ResponsiveHelper.isDesktop(context) ? 100 : 0),
      child: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            Images.completed,
            width: 20,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.isDesktop(context) ? 10 : 0,
        ),
        Image.asset(
          Images.cod,
          width: 50,
        ),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Text(
          'cash_after_service'.tr,
          style: ubuntuMedium,
        ),
        const SizedBox(
          height: Dimensions.paddingSizeLarge,
        ),
        SizedBox(
          height: ResponsiveHelper.isDesktop(context) ? 10 : 0,
        ),
      ]),
    );
  }
}

class DigitalPaymentMethodView extends StatelessWidget {
  final Function(int index) onTap;
  final List<DigitalPaymentMethod> paymentList;
  final JustTheController tooltipController;
  final String fromPage;
  const DigitalPaymentMethodView({
    super.key,
    required this.onTap,
    required this.paymentList,
    required this.tooltipController,
    required this.fromPage,
  });

  @override
  Widget build(BuildContext context) {
    List<String> offlinePaymentTooltipTextList = [
      'to_pay_offline_you_have_to_pay_the_bill_from_a_option_below',
      'save_the_necessary_information_that_is_necessary_to_identify_or_confirmation_of_the_payment',
      'insert_the_information_and_proceed'
    ];

    return GetBuilder<CheckOutController>(builder: (checkoutController) {
      return SingleChildScrollView(
          child: ListView.builder(
        itemCount: paymentList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          bool isSelected = paymentList[index] ==
              Get.find<CheckOutController>().selectedDigitalPaymentMethod;
          bool isOffline = paymentList[index].gateway == 'offline';

          return InkWell(
            onTap: isOffline ? null : () => onTap(index),
            child: Container(
              decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).hoverColor
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusDefault)),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: isOffline &&
                              !checkoutController.showOfflinePaymentInputData
                          ? () => onTap(index)
                          : null,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                height: Dimensions.paddingSizeLarge,
                                width: Dimensions.paddingSizeLarge,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.green
                                        : Theme.of(context).cardColor,
                                    border: Border.all(
                                        color:
                                            Theme.of(context).disabledColor)),
                                child: Icon(Icons.check,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 16),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                              isOffline
                                  ? const SizedBox()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      child: CustomImage(
                                        height: Dimensions.paddingSizeLarge,
                                        fit: BoxFit.contain,
                                        image: paymentList[index]
                                                .gatewayImageFullPath ??
                                            "",
                                      ),
                                    ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Text(
                                isOffline
                                    ? 'pay_offline'.tr
                                    : paymentList[index].label ?? "",
                                style: ubuntuMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault),
                              ),
                            ]),
                            isOffline
                                ? JustTheTooltip(
                                    backgroundColor: Colors.black87,
                                    controller: tooltipController,
                                    preferredDirection: AxisDirection.down,
                                    tailLength: 14,
                                    tailBaseWidth: 20,
                                    content: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeDefault),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "note".tr,
                                              style: ubuntuBold.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  offlinePaymentTooltipTextList
                                                      .map(
                                                        (element) => Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              bottom: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          child: Text(
                                                            "●  ${element.tr}",
                                                            style: ubuntuRegular
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white70),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ]),
                                    ),
                                    child: (isOffline && isSelected)
                                        ? InkWell(
                                            onTap: () =>
                                                tooltipController.showTooltip(),
                                            child: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )
                                        : const SizedBox(),
                                  )
                                : const SizedBox()
                          ]),
                    ),
                    if (isOffline && isSelected)
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeExtraLarge),
                        scrollDirection: Axis.horizontal,
                        child: checkoutController
                                .offlinePaymentModelList.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: checkoutController
                                    .offlinePaymentModelList
                                    .map((offlineMethod) => InkWell(
                                          onTap: () {
                                            if (isOffline) {
                                              checkoutController
                                                  .changePaymentMethod(
                                                      offlinePaymentModel:
                                                          offlineMethod);
                                            } else {
                                              checkoutController
                                                  .changePaymentMethod(
                                                      digitalMethod:
                                                          paymentList[index]);
                                            }

                                            bool isPartialPayment = fromPage ==
                                                    "custom-checkout"
                                                ? Get.find<CheckOutController>()
                                                        .totalAmount >
                                                    Get.find<CartController>()
                                                        .walletBalance
                                                : Get.find<CartController>()
                                                        .totalPrice >
                                                    Get.find<CartController>()
                                                        .walletBalance;
                                            double totalAmount = fromPage ==
                                                    "custom-checkout"
                                                ? Get.find<CheckOutController>()
                                                    .totalAmount
                                                : Get.find<CartController>()
                                                    .totalPrice;
                                            double dueAmount = totalAmount -
                                                (isPartialPayment
                                                    ? Get.find<CartController>()
                                                        .walletBalance
                                                    : 0);

                                            checkoutController
                                                .showOfflinePaymentData(
                                                    isShow: false);
                                            showDialog(
                                                context: Get.context!,
                                                builder: (ctx) =>
                                                    OfflinePaymentDialog(
                                                      totalAmount: Get.find<
                                                                      CartController>()
                                                                  .walletPaymentStatus &&
                                                              isPartialPayment
                                                          ? dueAmount
                                                          : totalAmount,
                                                      index: checkoutController
                                                          .offlinePaymentModelList
                                                          .indexOf(
                                                              offlineMethod),
                                                    ));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall),
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    Dimensions.paddingSizeSmall,
                                                horizontal: Dimensions
                                                    .paddingSizeExtraLarge),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(
                                                        checkoutController
                                                                    .selectedOfflineMethod ==
                                                                offlineMethod
                                                            ? 0.7
                                                            : 0.2,
                                                      )),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                            ),
                                            child: Text(
                                                offlineMethod.methodName ?? ''),
                                          ),
                                        ))
                                    .toList())
                            : Text(
                                "no_offline_payment_method_available".tr,
                                style: ubuntuRegular.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color),
                              ),
                      ),
                    (checkoutController.showOfflinePaymentInputData &&
                            isOffline &&
                            isSelected)
                        ? OfflinePaymentInputDataView(
                            customerInfoList: checkoutController
                                .selectedOfflineMethod?.customerInformation,
                          )
                        : const SizedBox()
                  ]),
            ),
          );
        },
      ));
    });
  }
}

class OfflinePaymentInputDataView extends StatelessWidget {
  final List<CustomerInformation>? customerInfoList;
  const OfflinePaymentInputDataView(
      {super.key, required this.customerInfoList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: customerInfoList != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeSmall),
                  child: Text(
                    "payment_info".tr,
                    style: ubuntuMedium,
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: customerInfoList!
                        .map((method) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeExtraSmall),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        method.fieldName
                                                ?.replaceAll("_", " ")
                                                .capitalizeFirst ??
                                            '',
                                        style: ubuntuRegular),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Text(
                                        ' :  ${Get.find<CheckOutController>().offlinePaymentInputField[customerInfoList!.indexOf(method)].text}',
                                        style: ubuntuRegular.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.8))),
                                  ]),
                            ))
                        .toList()),
              ],
            )
          : const SizedBox(),
    );
  }
}
