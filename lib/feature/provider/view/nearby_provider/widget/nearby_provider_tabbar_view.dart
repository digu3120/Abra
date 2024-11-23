import 'package:demandium/feature/provider/view/nearby_provider/widget/nearby_provider_filter_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderTaBarView extends StatelessWidget {
  final TabController? tabController;
  final LatLng? initialPosition;
  const NearbyProviderTaBarView(
      {super.key, this.tabController, this.initialPosition});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GetBuilder<NearbyProviderController>(
        builder: (nearbyProviderController) {
      int providerCount =
          nearbyProviderController.providerModel?.content?.total ?? 0;

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              if (ResponsiveHelper.isDesktop(context))
                Text('nearest_provider'.tr,
                    style: ubuntuMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.fontSizeLarge
                            : Dimensions.paddingSizeDefault)),
              const SizedBox(
                width: Dimensions.paddingSizeSmall,
              ),
              if (providerCount > 0)
                Text(
                    "${nearbyProviderController.providerModel?.content?.total ?? ""} ${'providers_found'.tr}",
                    style: ubuntuRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    )),
            ]),
            Row(children: [
              (nearbyProviderController.providerList != null &&
                      nearbyProviderController.providerList!.isNotEmpty)
                  ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 45,
                      margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeDefault,
                          bottom: Dimensions.paddingSizeDefault),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            4.0), // Padding for better visuals
                        child: Center(
                          child: Wrap(
                            children: [
                              TabBar(
                                controller: tabController,
                                indicator: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // background color for selected tab
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                labelColor:
                                    Colors.white, // text color for selected tab
                                unselectedLabelColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color, // text color for unselected tabs
                                tabs: [
                                  SizedBox(
                                      height: 34,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width < 400 ? 5 : 10),
                                        child: Tab(text: "list_view".tr),
                                      )),
                                  SizedBox(
                                      height: 34,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width < 400 ? 5 : 10),
                                        child: Tab(text: "map_view".tr),
                                      )),
                                ],
                                isScrollable:
                                    true, // Allows TabBar to be dynamically sized
                                indicatorSize: TabBarIndicatorSize
                                    .tab, // Matches indicator to tab size
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 75,
                    ),
              const SizedBox(
                width: 20,
              ),
              if (ResponsiveHelper.isDesktop(context))
                PopupMenuButton<String>(
                  tooltip: "",
                  constraints: const BoxConstraints(
                      maxWidth: Dimensions.webMaxWidth / 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(
                      Dimensions.radiusDefault,
                    )),
                    side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1)),
                  ),
                  position: PopupMenuPosition.under,
                  elevation: 1,
                  shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
                  itemBuilder: (BuildContext context) {
                    return ["Menu"].map((String option) {
                      return PopupMenuItem<String>(
                        onTap: null,
                        enabled: false,
                        value: option,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: Get.height * 0.7),
                            child: NearByFilterDialog(
                              showCrossButton: false,
                              initialPosition: initialPosition,
                            )),
                      );
                    }).toList();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall,
                        horizontal: Dimensions.paddingSizeLarge),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              Images.filter,
                              width: 16,
                              color: Colors.white,
                            ),
                            if (nearbyProviderController.isFilteredApplied())
                              Positioned(
                                top: -7,
                                left: -10,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Container(
                                    height: 8,
                                    width: 8,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(
                          width: Dimensions.paddingSizeSmall,
                        ),
                        Text(
                          'filter'.tr,
                          style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ])
          ]);
    });
  }
}
