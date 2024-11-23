import 'package:demandium/feature/booking/widget/repeat/repeat_history_expenssion_tile.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class RepeatBookingEditHistoryDialog extends StatelessWidget {
  const RepeatBookingEditHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: GetBuilder<BookingDetailsController>(
          builder: (bookingDetailsController) {
        List<RepeatHistory> editHistory =
            bookingDetailsController.bookingDetailsContent?.repeatEditHistory ??
                [];

        return SizedBox(
          width: Dimensions.webMaxWidth / 2,
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(
                  height: Dimensions.paddingSizeDefault * 2.5,
                ),
                ListView.builder(
                  itemCount: editHistory.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List<RepeatHistoryLog> historyLogs =
                        editHistory[index].repeatHistoryLogs ?? [];
                    double subTotal = 0;

                    for (var element in historyLogs) {
                      subTotal = subTotal +
                          (element.serviceCost ?? 0) * (element.quantity ?? 1);
                    }

                    return RepeatBookingHistoryExpansionTile(
                      titleWidget: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.05),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: Dimensions.paddingSizeSmall),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    textWidget(text: "booking_id".tr),
                                    textWidget(text: "edited_at".tr),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    textWidget(
                                        text:
                                            "# ${editHistory[index].readableId ?? ""}",
                                        textStyle: ubuntuRegular),
                                    textWidget(
                                      text: DateConverter.dateMonthYearTime(
                                              DateConverter
                                                  .isoUtcStringToLocalDate(
                                                      editHistory[index]
                                                          .createdAt!))
                                          .tr,
                                    ),
                                  ]),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(text: "total_qty".tr),
                                  textWidget(text: "remark".tr),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text:
                                          "${editHistory[index].oldQuantity ?? ""} → ${editHistory[index].newQuantity ?? ""}"
                                              .tr,
                                      textStyle: ubuntuMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeDefault)),
                                  textWidget(
                                      text: editHistory[index].isMultiple == 1
                                          ? "edited_multiple_booking".tr
                                          : "edited_only_this_single_booking"
                                              .tr
                                              .tr),
                                ]),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ]),
                      ),
                      children: [
                        ListView.builder(
                          itemCount: historyLogs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(children: [
                                      //Text(element.serviceName ?? "", style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                                      Text(
                                        historyLogs[index]
                                                .variantKey
                                                ?.replaceAll("-", " ")
                                                .capitalizeFirst ??
                                            "",
                                        style: ubuntuRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ]),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${historyLogs[index].quantity ?? 1} x ${PriceConverter.convertPrice(historyLogs[index].serviceCost ?? 0)}",
                                            style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                          Text(
                                            PriceConverter.convertPrice(
                                                (historyLogs[index]
                                                            .serviceCost ??
                                                        0) *
                                                    (historyLogs[index]
                                                            .quantity ??
                                                        1)),
                                            style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                        ])
                                  ]),
                            );
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        _SubTotalItemWidget(
                          title: "sub_total".tr,
                          additionalSign: "",
                          amount: subTotal,
                          boldText: false,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeTine,
                        ),

                        _SubTotalItemWidget(
                          title: "service_discount".tr,
                          additionalSign: "-",
                          amount: editHistory[index].totalDiscountAmount ?? 0,
                          boldText: false,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeTine,
                        ),

                        _SubTotalItemWidget(
                          title: "service_vat".tr,
                          additionalSign: "+",
                          amount: editHistory[index].totalTaxAmount ?? 0,
                          boldText: false,
                        ),

                        const SizedBox(
                          height: Dimensions.paddingSizeTine,
                        ),

                        // if((editHistory[index].extraFee ?? 0) > 0) _SubTotalItemWidget(
                        //   title: Get.find<SplashController>().configModel.content?.additionalChargeLabelName?.tr ?? "",
                        //   additionalSign: "+",
                        //   amount: editHistory[index].extraFee ?? 0,
                        //   boldText: false,
                        // ),
                        //
                        // const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        // Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        //   child: Divider(height: 0.5,thickness: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                        // ),
                        // const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        //
                        // _SubTotalItemWidget(
                        //   title: "grand_total".tr,
                        //   additionalSign: "",
                        //   amount: editHistory[index].totalBookingAmount ?? 0,
                        //   boldText: true,
                        // )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeDefault,
                )
              ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("edit_history_log".tr,
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }

  Widget textWidget({
    required String text,
    TextStyle? textStyle,
  }) {
    return Text(
      text,
      style: textStyle ?? ubuntuLight,
    );
  }
}

class _SubTotalItemWidget extends StatelessWidget {
  final String title;
  final double amount;
  final String additionalSign;
  final bool boldText;
  const _SubTotalItemWidget(
      {required this.title,
      required this.amount,
      required this.additionalSign,
      required this.boldText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title.tr,
                  style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault - 2,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color
                          ?.withOpacity(0.6)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeExtraSmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: Dimensions.paddingSizeDefault,
          ),
          Text(
            "${additionalSign != "" ? "($additionalSign)" : ""} ${PriceConverter.convertPrice(amount, isShowLongPrice: true)}",
            style: boldText
                ? ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault - 2,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color
                        ?.withOpacity(0.9))
                : ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault - 2,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color
                        ?.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
