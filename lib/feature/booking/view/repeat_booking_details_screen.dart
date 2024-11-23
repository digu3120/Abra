import 'package:demandium/common/models/popup_menu_model.dart';
import 'package:demandium/feature/booking/widget/repeat/repeat_booking_details_widget.dart';
import 'package:demandium/feature/booking/widget/repeat/repeat_booking_service_log_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class RepeatBookingDetailsScreen extends StatefulWidget {
  final String? bookingId;
  final String? fromPage;
  const RepeatBookingDetailsScreen(
      {super.key, required this.bookingId, this.fromPage});

  @override
  State<RepeatBookingDetailsScreen> createState() =>
      _RepeatBookingDetailsScreenState();
}

class _RepeatBookingDetailsScreenState extends State<RepeatBookingDetailsScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  TabController? tabController;

  @override
  void initState() {
    tabController =
        TabController(length: BookingDetailsTabs.values.length, vsync: this);
    Get.find<BookingDetailsController>()
        .resetBookingDetailsValue(resetBookingDetails: true);
    Get.find<BookingDetailsController>()
        .getBookingDetails(bookingId: widget.bookingId ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: () {
        if (widget.fromPage == 'fromNotification') {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }
      },
      child: Scaffold(
        endDrawer:
            ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
        appBar: CustomAppBar(
          title: "repeat_booking_details".tr,
          onBackPressed: () {
            if (widget.fromPage == 'fromNotification') {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            } else {
              if (Navigator.canPop(context)) {
                Get.back();
              } else {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }
            }
          },
          actionWidget: GetBuilder<BookingDetailsController>(
              builder: (bookingDetailsController) {
            String? bookingStatus =
                bookingDetailsController.bookingDetailsContent?.bookingStatus;
            return bookingStatus == "pending" || bookingStatus == "completed"
                ? PopupMenuButton<PopupMenuModel>(
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(
                        Dimensions.radiusDefault,
                      )),
                      side: BorderSide(
                          color: Theme.of(context).hintColor.withOpacity(0.1)),
                    ),
                    surfaceTintColor: Theme.of(context).cardColor,
                    position: PopupMenuPosition.under,
                    elevation: 8,
                    shadowColor: Theme.of(context).hintColor.withOpacity(0.3),
                    itemBuilder: (BuildContext context) {
                      return bookingDetailsController
                          .getPopupMenuList(bookingDetailsController
                                  .bookingDetailsContent?.bookingStatus ??
                              "")
                          .map((PopupMenuModel option) {
                        return PopupMenuItem<PopupMenuModel>(
                          value: option,
                          padding: EdgeInsets.zero,
                          height: 45,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: Dimensions.paddingSizeDefault,
                              ),
                              Icon(
                                option.icon,
                                size: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeSmall,
                              ),
                              Text(
                                option.title.tr,
                                style: ubuntuRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (option.title == "download_invoice") {
                              String languageCode =
                                  Get.find<LocalizationController>()
                                      .locale
                                      .languageCode;
                              String uri =
                                  "${AppConstants.baseUrl}${AppConstants.repeatBookingInvoiceUrl}${bookingDetailsController.bookingDetailsContent?.id}/$languageCode";
                              if (kDebugMode) {
                                print("Uri : $uri");
                              }
                              await _launchUrl(Uri.parse(uri));
                            } else if (option.title == "cancel") {
                              Get.dialog(
                                ConfirmationDialog(
                                  icon: Images.deleteProfile,
                                  title:
                                      'are_you_sure_to_cancel_this_full_booking'
                                          .tr,
                                  description: 'once_cancel_full_booking'.tr,
                                  noButtonText: "yes_cancel".tr,
                                  noButtonColor:
                                      Theme.of(context).colorScheme.primary,
                                  noTextColor: Colors.white,
                                  yesButtonText: "not_now".tr,
                                  yesButtonColor:
                                      Theme.of(context).colorScheme.error,
                                  yesTextColor: Colors.white,
                                  onYesPressed: () {
                                    Get.back();
                                  },
                                  onNoPressed: () async {
                                    Get.back();
                                    Get.dialog(const CustomLoader(),
                                        barrierDismissible: false);
                                    await bookingDetailsController
                                        .bookingCancel(
                                            bookingId: bookingDetailsController
                                                    .bookingDetailsContent
                                                    ?.id ??
                                                "");
                                    Get.back();
                                  },
                                ),
                                useSafeArea: false,
                              );
                            } else if (option.title == "review") {
                              showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ReviewRecommendationDialog(
                                  id: bookingDetailsController
                                      .bookingDetailsContent!.id!,
                                ),
                              );
                            }
                          },
                        );
                      }).toList();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Icon(Icons.more_vert_sharp),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      String languageCode = Get.find<LocalizationController>()
                          .locale
                          .languageCode;
                      String uri =
                          "${AppConstants.baseUrl}${AppConstants.repeatBookingInvoiceUrl}${bookingDetailsController.bookingDetailsContent?.id}/$languageCode";
                      if (kDebugMode) {
                        print("Uri : $uri");
                      }
                      await _launchUrl(Uri.parse(uri));
                    },
                    icon: const Icon(Icons.file_download_outlined));
          }),
        ),
        body: RefreshIndicator(
          onRefresh: () async => widget.bookingId != null
              ? Get.find<BookingDetailsController>()
                  .getBookingDetails(bookingId: widget.bookingId!)
              : null,
          child: widget.bookingId == null
              ? const NoDataScreen(
                  text: "no_data_found",
                  type: NoDataType.bookings,
                )
              : DefaultTabController(
                  length: 2,
                  child: TabBarView(controller: tabController, children: [
                    RepeatBookingDetailsWidget(tabController: tabController),
                    RepeatBookingServiceLogWidget(tabController: tabController),
                  ]),
                ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}

class RepeatBookingTabBar extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final TabController? tabController;
  const RepeatBookingTabBar(
      {super.key, this.tabController, required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
        builder: (bookingDetailsTabsController) {
      return Container(
        height: 45,
        color: Theme.of(context).cardColor,
        width: Dimensions.webMaxWidth,
        //padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Get.isDarkMode
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  controller: tabController,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      child: Text('booking_details'.tr),
                    ),
                    Tab(
                      child: Text('service_log'.tr),
                    ),
                  ],
                  onTap: (int? index) {
                    switch (index) {
                      case 0:
                        bookingDetailsTabsController.updateBookingStatusTabs(
                            BookingDetailsTabs.bookingDetails);
                        break;

                      case 1:
                        bookingDetailsTabsController
                            .updateBookingStatusTabs(BookingDetailsTabs.status);
                        break;
                    }
                  },
                ),
              ),
              !ResponsiveHelper.isDesktop(context)
                  ? const SizedBox()
                  : GetBuilder<BookingDetailsController>(
                      builder: (bookingDetailsController) {
                      return Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () async {
                                Get.dialog(const CustomLoader());
                                String languageCode =
                                    Get.find<LocalizationController>()
                                        .locale
                                        .languageCode;
                                String uri =
                                    "${AppConstants.baseUrl}${AppConstants.repeatBookingInvoiceUrl}${bookingDetails.id}/$languageCode";
                                if (kDebugMode) {
                                  print("Uri : $uri");
                                }
                                await _launchUrl(Uri.parse(uri));
                                Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeEight),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSeven),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Text("invoice".tr,
                                        style: ubuntuMedium.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    SizedBox(
                                        height: 15,
                                        width: 15,
                                        child:
                                            Image.asset(Images.downloadImage)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Get.find<AuthController>().isLoggedIn() &&
                                  (bookingDetails.bookingStatus ==
                                          "completed" ||
                                      bookingDetails.bookingStatus == "pending")
                              ? GetBuilder<ServiceBookingController>(
                                  builder: (serviceBookingController) {
                                    return InkWell(
                                      onTap: () {
                                        if (bookingDetails.bookingStatus ==
                                            "completed") {
                                          serviceBookingController
                                              .checkCartSubcategory(
                                                  bookingDetails.id!,
                                                  bookingDetails
                                                      .subCategoryId!);
                                        } else {
                                          Get.dialog(
                                            ConfirmationDialog(
                                              icon: Images.warning,
                                              title:
                                                  'are_you_sure_to_cancel_this_full_booking'
                                                      .tr,
                                              description:
                                                  'once_cancel_full_booking'.tr,
                                              noButtonText: "yes_cancel".tr,
                                              noButtonColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              noTextColor: Colors.white,
                                              yesButtonText: "not_now".tr,
                                              yesButtonColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              yesTextColor: Colors.white,
                                              onYesPressed: () {
                                                Get.back();
                                              },
                                              onNoPressed: () async {
                                                Get.back();
                                                Get.dialog(const CustomLoader(),
                                                    barrierDismissible: false);
                                                await bookingDetailsController
                                                    .bookingCancel(
                                                        bookingId:
                                                            bookingDetailsController
                                                                    .bookingDetailsContent
                                                                    ?.id ??
                                                                "");
                                                Get.back();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSeven),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeEight,
                                            horizontal:
                                                Dimensions.paddingSizeLarge),
                                        child: (serviceBookingController
                                                .isLoading)
                                            ? Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeDefault),
                                                child: SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                    )))
                                            : Text(
                                                bookingDetails.bookingStatus ==
                                                        "completed"
                                                    ? "rebook".tr
                                                    : "cancel_booking".tr,
                                                style: ubuntuMedium.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary)),
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          bookingDetails.bookingStatus == "completed" &&
                                  Get.find<AuthController>().isLoggedIn()
                              ? InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          ReviewRecommendationDialog(
                                        id: bookingDetails.id!,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeSmall),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeEight,
                                        horizontal:
                                            Dimensions.paddingSizeLarge),
                                    child: Text("review".tr,
                                        style: ubuntuMedium.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: Dimensions.paddingSizeSmall,
                          )
                        ],
                      ));
                    })
            ],
          ),
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
