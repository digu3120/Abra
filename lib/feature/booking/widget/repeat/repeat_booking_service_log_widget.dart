import 'package:demandium/common/models/popup_menu_model.dart';
import 'package:demandium/feature/booking/view/repeat_booking_details_screen.dart';
import 'package:demandium/feature/booking/view/web_booking_details_screen.dart';
import 'package:demandium/feature/booking/widget/booking_screen_shimmer.dart';
import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
import 'package:demandium/helper/booking_helper.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class RepeatBookingServiceLogWidget extends StatelessWidget {
  final TabController? tabController;
  const RepeatBookingServiceLogWidget({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
        builder: (bookingDetailsController) {
      BookingDetailsContent? bookingDetails =
          bookingDetailsController.bookingDetailsContent;
      RepeatBooking? nextBooking =
          BookingHelper.getNextUpcomingRepeatBooking(bookingDetails);

      List<RepeatBooking> alreadyProvided = [];
      List<RepeatBooking> upcomingBooking = [];

      bookingDetailsController.bookingDetailsContent?.repeatBookingList
          ?.forEach((element) {
        if (element.bookingStatus == "completed" ||
            element.bookingStatus == "canceled") {
          alreadyProvided.add(element);
        } else {
          if (nextBooking?.readableId != element.readableId) {
            upcomingBooking.add(element);
          }
        }
      });

      return bookingDetails != null
          ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(children: [
                SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)
                          ? 0
                          : Dimensions.paddingSizeDefault,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: Get.height * 0.7),
                      child: Column(children: [
                        ResponsiveHelper.isDesktop(context)
                            ? BookingDetailsTopCard(
                                bookingDetailsContent: bookingDetails)
                            : const SizedBox(),
                        RepeatBookingTabBar(
                          tabController: tabController,
                          bookingDetails: bookingDetails,
                        ),
                        SizedBox(
                            height: nextBooking != null
                                ? Dimensions.paddingSizeDefault
                                : 0),
                        nextBooking != null
                            ? _ServiceLogItem(
                                title: "next_service",
                                serviceList: [nextBooking],
                              )
                            : const SingleChildScrollView(),
                        alreadyProvided.isNotEmpty
                            ? const SizedBox(
                                height: Dimensions.paddingSizeLarge)
                            : const SizedBox(),
                        alreadyProvided.isNotEmpty
                            ? _ServiceLogItem(
                                title: "already_provided",
                                serviceList: alreadyProvided,
                              )
                            : const SizedBox(),
                        upcomingBooking.isNotEmpty
                            ? const SizedBox(
                                height: Dimensions.paddingSizeLarge)
                            : const SizedBox(),
                        upcomingBooking.isNotEmpty
                            ? _ServiceLogItem(
                                title: "upcoming",
                                serviceList: upcomingBooking,
                              )
                            : const SizedBox(),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge),
                      ]),
                    ),
                  ),
                ),
                ResponsiveHelper.isDesktop(context)
                    ? const FooterView()
                    : const SizedBox(),
              ]),
            )
          : const SingleChildScrollView(child: BookingScreenShimmer());
    });
  }
}

class _ServiceLogItem extends StatelessWidget {
  final String title;
  final List<RepeatBooking?> serviceList;
  const _ServiceLogItem({required this.title, required this.serviceList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
        builder: (bookingDetailsController) {
      return Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Theme.of(context).cardColor.withOpacity(0.4)
              : Theme.of(context).hintColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context)
                ? Dimensions.webMaxWidth / 5
                : 0),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr,
              style: ubuntuMedium,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            ListView.separated(
              itemCount: serviceList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${'booking_id'.tr} # ${serviceList[index]?.readableId}",
                                        style: ubuntuMedium.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      PopupMenuButton<PopupMenuModel>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                            Dimensions.radiusDefault,
                                          )),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.1)),
                                        ),
                                        surfaceTintColor:
                                            Theme.of(context).cardColor,
                                        position: PopupMenuPosition.under,
                                        elevation: 8,
                                        shadowColor: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.3),
                                        itemBuilder: (BuildContext context) {
                                          return bookingDetailsController
                                              .getPServiceLogMenuList(
                                                  status: serviceList[index]
                                                          ?.bookingStatus ??
                                                      "",
                                                  nextService:
                                                      title == "next_service")
                                              .map((PopupMenuModel option) {
                                            return PopupMenuItem<
                                                PopupMenuModel>(
                                              value: option,
                                              height: 35,
                                              onTap: () async {
                                                if (option.title ==
                                                    "booking_details") {
                                                  Get.toNamed(RouteHelper
                                                      .getBookingDetailsScreen(
                                                    subBookingId:
                                                        serviceList[index]!.id!,
                                                  ));
                                                } else if (option.title ==
                                                    "download_invoice") {
                                                  String uri = "";
                                                  String languageCode = Get.find<
                                                          LocalizationController>()
                                                      .locale
                                                      .languageCode;
                                                  uri =
                                                      "${AppConstants.baseUrl}${AppConstants.singleRepeatBookingInvoiceUrl}${serviceList[index]!.id!}/$languageCode";

                                                  if (kDebugMode) {
                                                    print("Uri : $uri");
                                                  }
                                                  await _launchUrl(
                                                      Uri.parse(uri));
                                                } else if (option.title ==
                                                    "cancel") {
                                                  Get.dialog(
                                                    ConfirmationDialog(
                                                      icon: Images.warning,
                                                      title:
                                                          'are_you_sure_to_cancel_your_order'
                                                              .tr,
                                                      description:
                                                          'your_order_will_be_cancel'
                                                              .tr,
                                                      noButtonText:
                                                          "yes_cancel".tr,
                                                      noButtonColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      noTextColor: Colors.white,
                                                      yesButtonText:
                                                          "not_now".tr,
                                                      yesButtonColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .error,
                                                      yesTextColor:
                                                          Colors.white,
                                                      onYesPressed: () {
                                                        Get.back();
                                                      },
                                                      onNoPressed: () async {
                                                        Get.back();
                                                        Get.dialog(
                                                            const CustomLoader(),
                                                            barrierDismissible:
                                                                false);
                                                        await Get.find<
                                                                BookingDetailsController>()
                                                            .subBookingCancel(
                                                          subBookingId:
                                                              serviceList[
                                                                      index]!
                                                                  .id!,
                                                        );
                                                        Get.back();
                                                      },
                                                    ),
                                                    useSafeArea: false,
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  Icon(
                                                    option.icon,
                                                    size: Dimensions
                                                        .fontSizeLarge,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall,
                                                  ),
                                                  Text(
                                                    option.title.tr,
                                                    style:
                                                        ubuntuRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList();
                                        },
                                        child: Icon(
                                          Icons.more_vert_sharp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color
                                              ?.withOpacity(0.6),
                                        ),
                                      ),
                                    ]),
                                title != "upcoming"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: BookingStatusButtonWidget(
                                          bookingStatus:
                                              serviceList[index]?.bookingStatus,
                                        ),
                                      )
                                    : const SizedBox()
                              ]),
                          (title == "upcoming")
                              ? Text(
                                  DateConverter.dateMonthYearTime(
                                      DateTime.tryParse(serviceList[index]!
                                          .serviceSchedule!)),
                                  style: ubuntuLight,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.paddingSizeDefault),
                                  child: DottedBorder(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                    dashPattern: const [4, 2],
                                    strokeWidth: 1.1,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(
                                        Dimensions.radiusDefault),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeDefault,
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.05)),
                                      child: ResponsiveHelper.isDesktop(context)
                                          ? Row(children: [
                                              Text("scheduled_at".tr,
                                                  style: ubuntuMedium),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeEight),
                                              Text(
                                                DateConverter.dateMonthYearTime(
                                                    DateTime.tryParse(
                                                        serviceList[index]!
                                                            .serviceSchedule!)),
                                                style: ubuntuLight,
                                              ),
                                            ])
                                          : Column(children: [
                                              const Row(),
                                              Text("scheduled_at".tr,
                                                  style: ubuntuRegular),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeEight),
                                              Text(
                                                DateConverter.dateMonthYearTime(
                                                    DateTime.tryParse(
                                                        serviceList[index]!
                                                            .serviceSchedule!)),
                                                style: ubuntuLight,
                                              ),
                                            ]),
                                    ),
                                  ),
                                ),
                        ]),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: Dimensions.paddingSizeSmall);
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
