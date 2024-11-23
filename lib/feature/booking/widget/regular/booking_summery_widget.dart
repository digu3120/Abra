import 'package:demandium/helper/booking_helper.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class BookingSummeryWidget extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  const BookingSummeryWidget({super.key, required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    double paidAmount = 0;

    double totalBookingAmount = bookingDetails.totalBookingAmount ?? 0;
    bool isPartialPayment = bookingDetails.partialPayments != null &&
        bookingDetails.partialPayments!.isNotEmpty;
    double subTotal = BookingHelper.getSubTotalCost(bookingDetails);
    if (isPartialPayment) {
      bookingDetails.partialPayments?.forEach((element) {
        paidAmount = paidAmount + (element.paidAmount ?? 0);
      });
    } else {
      paidAmount = totalBookingAmount - (bookingDetails.additionalCharge ?? 0);
    }
    double dueAmount = totalBookingAmount - paidAmount;
    double additionalCharge = isPartialPayment
        ? totalBookingAmount - paidAmount
        : bookingDetails.additionalCharge ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow:
              Get.find<ThemeController>().darkTheme ? null : searchBoxShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
          Padding(
              padding: ResponsiveHelper.isDesktop(context)
                  ? const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge)
                  : const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
              child: Text('booking_summery'.tr,
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge!.color))),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
          Container(
            padding: ResponsiveHelper.isDesktop(context)
                ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge)
                : const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
            child: SizedBox(
              height: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('service_info'.tr,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                          decoration: TextDecoration.none,
                        )),
                    Text('price'.tr,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                          decoration: TextDecoration.none,
                        )),
                  ]),
            ),
          ),
          Padding(
            padding: ResponsiveHelper.isDesktop(context)
                ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall)
                : EdgeInsets.zero,
            child: Column(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    return _ServiceInfoItem(
                      bookingService: bookingDetails.bookingDetails?[index],
                      index: index,
                    );
                  },
                  itemCount: bookingDetails.bookingDetails?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'sub_total'.tr,
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            PriceConverter.convertPrice(subTotal,
                                isShowLongPrice: true),
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color),
                          ),
                        ),
                      ]),
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('service_discount'.tr,
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                          overflow: TextOverflow.ellipsis),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                            "(-) ${PriceConverter.convertPrice(bookingDetails.totalDiscountAmount ?? 0)}",
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)),
                      ),
                    ],
                  ),
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'coupon_discount'.tr,
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          '(-) ${PriceConverter.convertPrice(bookingDetails.totalCouponDiscountAmount ?? 0)}',
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'campaign_discount'.tr,
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                            '(-) ${PriceConverter.convertPrice(bookingDetails.totalCampaignDiscountAmount ?? 0)}',
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!)),
                      ),
                    ],
                  ),
                ),
                if (bookingDetails.totalReferralDiscountAmount != null &&
                    bookingDetails.totalReferralDiscountAmount! > 0)
                  Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                if (bookingDetails.totalReferralDiscountAmount != null &&
                    bookingDetails.totalReferralDiscountAmount! > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'referral_discount'.tr,
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                              '(-) ${PriceConverter.convertPrice(bookingDetails.totalReferralDiscountAmount ?? 0)}',
                              style: ubuntuRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!)),
                        ),
                      ],
                    ),
                  ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'service_vat'.tr,
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                            '(+) ${PriceConverter.convertPrice(bookingDetails.totalTaxAmount!.toDouble(), isShowLongPrice: true)}',
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)),
                      ),
                    ],
                  ),
                ),
                if (bookingDetails.extraFee != null &&
                    bookingDetails.extraFee! > 0)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault,
                        top: Dimensions.paddingSizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Get.find<SplashController>()
                                  .configModel
                                  .content
                                  ?.additionalChargeLabelName ??
                              "",
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "(+) ${PriceConverter.convertPrice(bookingDetails.extraFee ?? 0, isShowLongPrice: true)}",
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      ],
                    ),
                  ),
                if (bookingDetails.additionalCharge != null &&
                    additionalCharge < 0 &&
                    (bookingDetails.paymentMethod != "cash_after_service" ||
                        bookingDetails.partialPayments!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "refund".tr,
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          PriceConverter.convertPrice(additionalCharge,
                              isShowLongPrice: true),
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      ],
                    ),
                  ),
                Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
                Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
                !isPartialPayment &&
                        bookingDetails.paymentMethod != "wallet_payment"
                    ? (additionalCharge == 0) ||
                            bookingDetails.paymentMethod == "cash_after_service"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'grand_total'.tr,
                                  style: ubuntuBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    PriceConverter.convertPrice(
                                        bookingDetails.totalBookingAmount!
                                            .toDouble(),
                                        isShowLongPrice: true),
                                    style: ubuntuBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: DottedBorder(
                              dashPattern: const [8, 4],
                              strokeWidth: 1.1,
                              borderType: BorderType.RRect,
                              color: Theme.of(context).colorScheme.primary,
                              radius: const Radius.circular(
                                  Dimensions.radiusDefault),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.02),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeSmall),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'grand_total'.tr,
                                          style: ubuntuBold.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            PriceConverter.convertPrice(
                                                totalBookingAmount,
                                                isShowLongPrice: true),
                                            style: ubuntuBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),

                                    // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    //   Text("${"paid_amount".tr} (${bookingDetailsContent.paymentMethod.toString().tr})",
                                    //     style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                    //     overflow: TextOverflow.ellipsis,),
                                    //   Directionality(
                                    //     textDirection: TextDirection.ltr,
                                    //     child: Text( PriceConverter.convertPrice( paidAmount, isShowLongPrice: true),
                                    //       style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),),
                                    //   )]
                                    // ),
                                    //
                                    // SizedBox(height: additionalCharge > 0 ? Dimensions.paddingSizeSmall : 0),

                                    additionalCharge > 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                  "${(bookingDetails.bookingStatus == "pending" || bookingDetails.bookingStatus == "accepted" || bookingDetails.bookingStatus == "ongoing") ? "due_amount".tr : "paid_amount".tr} (${"cash_after_service".tr})",
                                                  style: ubuntuRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: Text(
                                                    PriceConverter.convertPrice(
                                                        additionalCharge,
                                                        isShowLongPrice: true),
                                                    style:
                                                        ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                  ),
                                                )
                                              ])
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          )
                    : !isPartialPayment &&
                            bookingDetails.paymentMethod == "wallet_payment"
                        ? Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'grand_total'.tr,
                                    style: ubuntuBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                        PriceConverter.convertPrice(
                                            bookingDetails.totalBookingAmount!
                                                .toDouble(),
                                            isShowLongPrice: true),
                                        style: ubuntuBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeSmall,
                              ),
                              DottedBorder(
                                dashPattern: const [8, 4],
                                strokeWidth: 1.1,
                                borderType: BorderType.RRect,
                                color: Theme.of(context).colorScheme.primary,
                                radius: const Radius.circular(
                                    Dimensions.radiusDefault),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.02),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall,
                                      vertical: Dimensions.paddingSizeSmall),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (bookingDetails.additionalCharge! <=
                                                  0)
                                              ? 'total_order_amount_has_been_paid_by_customer'
                                                  .tr
                                              : "has_been_paid_by_customer".tr,
                                          style: ubuntuMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeSmall,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    Images.walletSmall,
                                                    width: 17,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  Text(
                                                    'via_wallet'.tr,
                                                    style:
                                                        ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Text(
                                                  PriceConverter.convertPrice(
                                                      paidAmount,
                                                      isShowLongPrice: true),
                                                  style: ubuntuRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color),
                                                ),
                                              )
                                            ]),
                                        if (additionalCharge > 0)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${(bookingDetails.bookingStatus == "pending" || bookingDetails.bookingStatus == "accepted" || bookingDetails.bookingStatus == "ongoing") ? "due_amount".tr : "paid_amount".tr} (${"cash_after_service".tr})",
                                                    style:
                                                        ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    child: Text(
                                                      PriceConverter
                                                          .convertPrice(
                                                              additionalCharge,
                                                              isShowLongPrice:
                                                                  true),
                                                      style: ubuntuRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color),
                                                    ),
                                                  )
                                                ]),
                                          )
                                      ]),
                                ),
                              ),
                            ]),
                          )
                        : isPartialPayment
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: DottedBorder(
                                  dashPattern: const [8, 4],
                                  strokeWidth: 1.1,
                                  borderType: BorderType.RRect,
                                  color: Theme.of(context).colorScheme.primary,
                                  radius: const Radius.circular(
                                      Dimensions.radiusDefault),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.02),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeSmall,
                                        vertical: Dimensions.paddingSizeSmall),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'grand_total'.tr,
                                              style: ubuntuBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Text(
                                                PriceConverter.convertPrice(
                                                    totalBookingAmount,
                                                    isShowLongPrice: true),
                                                style: ubuntuBold.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeSmall,
                                        ),
                                        ListView.builder(
                                          itemBuilder: (context, index) {
                                            String payWith = bookingDetails
                                                    .partialPayments?[index]
                                                    .paidWith ??
                                                "";

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          Images.walletSmall,
                                                          width: 15,
                                                        ),
                                                        const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall,
                                                        ),
                                                        Text(
                                                          '${payWith == "cash_after_service" ? "paid_amount".tr : payWith == "digital" && bookingDetails.paymentMethod == "offline_payment" ? "" : 'paid_by'.tr} '
                                                          '${payWith == "digital" ? "${bookingDetails.paymentMethod}".tr : (payWith == "cash_after_service" ? "(${'cash_after_service'.tr})" : payWith).tr}',
                                                          style: ubuntuRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: Text(
                                                        PriceConverter.convertPrice(
                                                            bookingDetails
                                                                    .partialPayments?[
                                                                        index]
                                                                    .paidAmount ??
                                                                0,
                                                            isShowLongPrice:
                                                                true),
                                                        style: ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                      ),
                                                    )
                                                  ]),
                                            );
                                          },
                                          itemCount: bookingDetails
                                              .partialPayments?.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                        ),
                                        bookingDetails.partialPayments
                                                        ?.length ==
                                                    1 &&
                                                dueAmount > 0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                    Text(
                                                      "${(bookingDetails.bookingStatus == "pending" || bookingDetails.bookingStatus == "accepted" || bookingDetails.bookingStatus == "ongoing") ? "due_amount".tr : "paid_amount".tr} (${"cash_after_service".tr})",
                                                      style: ubuntuRegular
                                                          .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                dueAmount,
                                                                isShowLongPrice:
                                                                    true),
                                                        style: ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                      ),
                                                    )
                                                  ])
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'grand_total'.tr,
                                        style: ubuntuBold.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          PriceConverter.convertPrice(
                                              totalBookingAmount,
                                              isShowLongPrice: true),
                                          style: ubuntuBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ]),
                              )
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        ],
      ),
    );
  }
}

class _ServiceInfoItem extends StatelessWidget {
  final int index;

  final ItemService? bookingService;
  const _ServiceInfoItem({required this.bookingService, required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                bookingService?.serviceName ?? "",
                style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color
                        ?.withOpacity(0.9)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              PriceConverter.convertPrice(
                BookingHelper.getBookingServiceUnitConst(bookingService),
                isShowLongPrice: true,
              ),
              style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color
                      ?.withOpacity(0.9)),
            ),
          ],
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall - 2,
        ),
        if (bookingService?.variantKey != null)
          Padding(
            padding:
                const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              Text(
                bookingService?.variantKey
                        ?.replaceAll("-", " ")
                        .capitalizeFirst ??
                    "",
                style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7)),
              ),
              Container(
                height: 10,
                width: 0.5,
                color: Theme.of(context).hintColor,
                margin: const EdgeInsets.only(
                    left: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall,
                    top: 5),
              ),
              Row(children: [
                Text(
                  "${"qty".tr} : ${bookingService?.quantity}",
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ),
              ]),
            ]),
          ),

        _ServiceItemText(
          title: "unit_price".tr,
          amount: bookingService?.serviceCost ?? 0,
        ),

        // const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        // (bookingService?.discountAmount ?? 0) > 0 ? _ServiceItemText(title: "discount".tr,
        //     amount: bookingService?.discountAmount ?? 0)
        //     : const SizedBox(),
        //
        // (bookingService?.campaignDiscountAmount ?? 0) > 0
        //     ? _ServiceItemText(title: "campaign".tr,
        //     amount: bookingService?.campaignDiscountAmount ?? 0)
        //     : const SizedBox(),
        //
        // (bookingService?.overallCouponDiscountAmount ?? 0) > 0
        //     ? _ServiceItemText(title: "coupon".tr, amount: bookingService?.overallCouponDiscountAmount?? 0)
        //     : const SizedBox(),
        //
        // bookingService?.service != null && (bookingService?.service?.tax??0) > 0
        //     ? _ServiceItemText(
        //   title: "tax".tr, amount: bookingService?.taxAmount?? 0,)
        //     : const SizedBox(),
      ]),
    );
  }
}

class _ServiceItemText extends StatelessWidget {
  final String title;
  final double amount;

  const _ServiceItemText({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.7)),
          ),
          Text(
            PriceConverter.convertPrice(amount, isShowLongPrice: true),
            style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
