import 'package:demandium/feature/provider/widgets/provider_details_shimmer.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderDetailsScreen extends StatefulWidget {
  final String providerId;
  const ProviderDetailsScreen({super.key, required this.providerId});

  @override
  ProviderDetailsScreenState createState() => ProviderDetailsScreenState();
}

class ProviderDetailsScreenState extends State<ProviderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    Get.find<ProviderBookingController>()
        .getProviderDetailsData(widget.providerId, true)
        .then((value) {
      tabController = TabController(
          length: Get.find<ProviderBookingController>().categoryItemList.length,
          vsync: this);
      Get.find<CartController>().updatePreselectedProvider(null);
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: CustomAppBar(
        title: "provider_details".tr,
        showCart: true,
      ),
      body: Center(
        child: GetBuilder<ProviderBookingController>(
          builder: (providerBookingController) {
            if (providerBookingController.providerDetailsContent != null) {
              if (providerBookingController.categoryItemList.isEmpty) {
                return Column(
                  children: [
                    if (providerBookingController.providerDetailsContent
                            ?.provider?.serviceAvailability ==
                        0)
                      Container(
                        width: Dimensions.webMaxWidth,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.1),
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.error))),
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: Dimensions.paddingSizeLarge),
                        child: Center(
                            child: Text(
                          'provider_is_currently_unavailable'.tr,
                          style: ubuntuMedium,
                        )),
                      ),
                    SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: ProviderDetailsTopCard(
                          providerId: widget.providerId,
                        )),
                    SizedBox(
                      height: Get.height * 0.6,
                      width: Dimensions.webMaxWidth,
                      child: Center(
                        child: Text('no_subscribed_subcategories_available'.tr),
                      ),
                    ),
                  ],
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (providerBookingController.providerDetailsContent
                              ?.provider?.serviceAvailability ==
                          0)
                        SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.1),
                                border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error))),
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault,
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Center(
                                child: Text(
                              'provider_is_currently_unavailable'.tr,
                              style: ubuntuMedium,
                            )),
                          ),
                        ),
                      SizedBox(
                        height: Get.height * 0.9,
                        width: Dimensions.webMaxWidth,
                        child: VerticalScrollableTabView(
                          tabController: tabController,
                          listItemData:
                              providerBookingController.categoryItemList,
                          verticalScrollPosition: VerticalScrollPosition.begin,
                          eachItemChild: (object, index) => CategorySection(
                            category: object as CategoryModelItem,
                            providerData: providerBookingController
                                .providerDetailsContent?.provider,
                          ),
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Get.isDarkMode
                                  ? null
                                  : Theme.of(context).cardColor,
                              pinned: true,
                              leading: const SizedBox(),
                              actions: const [SizedBox()],
                              flexibleSpace: ProviderDetailsTopCard(
                                providerId: widget.providerId,
                              ),
                              toolbarHeight: ResponsiveHelper.isDesktop(context)
                                  ? 170
                                  : 220,
                              elevation: 0,
                              bottom: AppBar(
                                automaticallyImplyLeading: false,
                                backgroundColor: Theme.of(context).cardColor,
                                elevation: 0,
                                leadingWidth: 0,
                                centerTitle: false,
                                actions: const [SizedBox()],
                                title: Container(
                                  height: 45,
                                  width: Dimensions.webMaxWidth,
                                  color: Theme.of(context).cardColor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0),
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 0.5),
                                      ),
                                    ),
                                    child: TabBar(
                                      isScrollable: true,
                                      controller: tabController,
                                      indicatorColor:
                                          Theme.of(context).colorScheme.primary,
                                      labelColor:
                                          Theme.of(context).colorScheme.primary,
                                      unselectedLabelColor: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.7),
                                      unselectedLabelStyle: ubuntuRegular,
                                      tabs: providerBookingController
                                          .categoryItemList
                                          .map((e) {
                                        return Tab(text: e.title);
                                      }).toList(),
                                      onTap: (index) {
                                        VerticalScrollableTabBarStatus.setIndex(
                                            index);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? const FooterView()
                          : const SizedBox()
                    ],
                  ),
                );
              }
            } else {
              return const FooterBaseView(child: ProviderDetailsShimmer());
            }
          },
        ),
      ),
    );
  }
}
