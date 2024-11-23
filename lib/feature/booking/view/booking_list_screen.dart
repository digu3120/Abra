import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_item_card.dart';
import 'package:demandium/feature/booking/widget/booking_status_tabs.dart';

class BookingListScreen extends StatefulWidget {
  final bool isFromMenu;
  const BookingListScreen({super.key, this.isFromMenu = false});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    Get.find<ServiceBookingController>().getAllBookingService(
      offset: 1,
      bookingStatus: "all",
      isFromPagination: false,
      serviceType: "all",
    );
    Get.find<ServiceBookingController>()
        .updateBookingStatusTabs(BookingStatusTabs.all, firstTimeCall: false);
    Get.find<ServiceBookingController>().updateSelectedServiceType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController bookingScreenScrollController = ScrollController();
    return Scaffold(
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: CustomAppBar(
        isBackButtonExist: widget.isFromMenu ? true : false,
        onBackPressed: () => Get.back(),
        title: "my_bookings".tr,
        actionWidget: const FilterPopUpMenuWidget(),
      ),
      body: GetBuilder<ServiceBookingController>(
        builder: (serviceBookingController) {
          List<BookingModel>? bookingList =
              serviceBookingController.bookingList;
          return CustomScrollView(
              controller: bookingScreenScrollController,
              slivers: [
                if (serviceBookingController.selectedServiceType !=
                        ServiceType.all &&
                    !ResponsiveHelper.isDesktop(context))
                  SliverPersistentHeader(
                    delegate: ServiceRequestTopTitle(),
                    pinned: true,
                    floating: true,
                  ),
                SliverPersistentHeader(
                  delegate: ServiceRequestSectionMenu(),
                  pinned: true,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeDefault
                          : 0),
                ),
                serviceBookingController.bookingList != null
                    ? SliverToBoxAdapter(
                        child: bookingList!.isNotEmpty
                            ? Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: Dimensions.webMaxWidth,
                                      minHeight: Get.height * 0.7),
                                  child: PaginatedListView(
                                    scrollController:
                                        bookingScreenScrollController,
                                    totalSize: serviceBookingController
                                        .bookingContent!.total!,
                                    onPaginate: (int offset) async =>
                                        await serviceBookingController
                                            .getAllBookingService(
                                                offset: offset,
                                                bookingStatus:
                                                    serviceBookingController
                                                        .selectedBookingStatus
                                                        .name
                                                        .toLowerCase(),
                                                isFromPagination: true,
                                                serviceType:
                                                    serviceBookingController
                                                        .selectedServiceType
                                                        .name),
                                    offset: serviceBookingController
                                        .bookingContent?.currentPage,
                                    itemView: GridView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 0
                                                : Dimensions.paddingSizeDefault,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 2
                                                : 1,
                                        mainAxisExtent:
                                            Get.find<LocalizationController>()
                                                    .isLtr
                                                ? 140
                                                : 175,
                                        crossAxisSpacing:
                                            Dimensions.paddingSizeDefault,
                                        mainAxisSpacing:
                                            Dimensions.paddingSizeDefault,
                                      ),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: bookingList.length,
                                      itemBuilder: (context, index) {
                                        return BookingItemCard(
                                            bookingModel:
                                                bookingList.elementAt(index),
                                            index: index);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: SizedBox(
                                  height: Get.height * 0.7,
                                  width: Dimensions.webMaxWidth,
                                  child: NoDataScreen(
                                    text: 'no_booking_request_available'.tr,
                                    type: NoDataType.bookings,
                                  ),
                                ),
                              ),
                      )
                    : const SliverToBoxAdapter(
                        child: Center(
                            child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: BookingListItemShimmer())),
                      ),
                SliverToBoxAdapter(
                  child: ResponsiveHelper.isDesktop(context)
                      ? const FooterView()
                      : const SizedBox(),
                )
              ]);
        },
      ),
    );
  }
}

class BookingListItemShimmer extends StatelessWidget {
  const BookingListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 130 : 120,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeSmall
            : Dimensions.paddingSizeExtraSmall,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall - 3,
            horizontal: ResponsiveHelper.isDesktop(context)
                ? 0
                : Dimensions.paddingSizeDefault,
          ),
          child: Shimmer(
              child: Container(
            height: 90,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
              boxShadow: Get.isDarkMode
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.grey[300]!,
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeSmall,
                      ),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeSmall,
                      ),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 17,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                    Container(
                      height: 15,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        );
      },
    );
  }
}

class ServiceRequestTopTitle extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<ServiceBookingController>(
        builder: (serviceBookingController) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            serviceBookingController.selectedServiceType == ServiceType.regular
                ? "regular_booking".tr
                : "repeat_booking".tr,
          ),
        ),
      );
    });
  }

  @override
  double get maxExtent => 30;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class FilterPopUpMenuWidget extends StatelessWidget {
  const FilterPopUpMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
        builder: (serviceBookingController) {
      List<String> bookingFilterList = [
        'all_booking',
        "regular_booking",
        "repeat_booking"
      ];

      return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(
              Dimensions.radiusSmall,
            )),
            side: BorderSide(
                color: Theme.of(context).hintColor.withOpacity(0.1))),
        surfaceTintColor: Theme.of(context).cardColor,
        position: PopupMenuPosition.under,
        elevation: 8,
        shadowColor: Theme.of(context).hintColor.withOpacity(0.3),
        padding: EdgeInsets.zero,
        menuPadding: EdgeInsets.zero,
        itemBuilder: (BuildContext context) {
          return bookingFilterList.map((String option) {
            ServiceType type = option == "regular_booking"
                ? ServiceType.regular
                : option == "repeat_booking"
                    ? ServiceType.repeat
                    : ServiceType.all;
            return PopupMenuItem<String>(
              value: option,
              padding: EdgeInsets.zero,
              height: 45,
              child: serviceBookingController.selectedServiceType == type
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(Get.isDarkMode ? 0.2 : 0.08),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(option.tr,
                              style: ubuntuRegular.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        option.tr,
                        style: ubuntuRegular,
                      ),
                    ),
              onTap: () {
                Get.find<ServiceBookingController>().updateSelectedServiceType(
                    type: option == "regular_booking"
                        ? ServiceType.regular
                        : option == "repeat_booking"
                            ? ServiceType.repeat
                            : ServiceType.all);
              },
            );
          }).toList();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.filter_list,
                color: ResponsiveHelper.isDesktop(context)
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              if (serviceBookingController.selectedServiceType !=
                  ServiceType.all)
                Positioned(
                  right: -5,
                  bottom: ResponsiveHelper.isDesktop(context) ? 0 : 13,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 13,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
