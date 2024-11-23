import 'package:demandium/feature/provider/view/nearby_provider/widget/nearby_provider_listview.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearByProviderMapView extends StatefulWidget {
  final Function(bool)? onValueChanged;
  final LatLng? initialPosition;
  const NearByProviderMapView(
      {super.key, this.onValueChanged, this.initialPosition});

  @override
  State<NearByProviderMapView> createState() => _NearByProviderMapViewState();
}

class _NearByProviderMapViewState extends State<NearByProviderMapView> {
  @override
  void initState() {
    super.initState();

    Get.find<NearbyProviderController>().scrollController =
        AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
  }

  void _onPanStart() {
    if (widget.onValueChanged != null) {
      setState(() {
        widget.onValueChanged!(true);
      });
    }
  }

  void _onPanEnd() {
    if (widget.onValueChanged != null) {
      setState(() {
        widget.onValueChanged!(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(
        builder: (nearbyProviderController) {
      return nearbyProviderController.providerList != null &&
              nearbyProviderController.providerList!.isNotEmpty
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ResponsiveHelper.isDesktop(context)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount:
                            nearbyProviderController.providerList?.length,
                        controller: nearbyProviderController.scrollController,
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                right: Get.find<LocalizationController>().isLtr
                                    ? Dimensions.paddingSizeDefault
                                    : 0,
                                left: Get.find<LocalizationController>().isLtr
                                    ? 0
                                    : Dimensions.paddingSizeDefault,
                                bottom: Dimensions.paddingSizeSmall),
                            child: AutoScrollTag(
                              controller:
                                  nearbyProviderController.scrollController!,
                              key: ValueKey(index),
                              index: index,
                              child: NearbyProviderMapItemView(
                                providerData: nearbyProviderController
                                    .providerList![index],
                                index: index,
                                googleMapController:
                                    nearbyProviderController.mapController,
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                      ),
                    )
                  : const SizedBox(),
              ResponsiveHelper.isDesktop(context)
                  ? const SizedBox(
                      width: Dimensions.paddingSizeSmall,
                    )
                  : const SizedBox(),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          ResponsiveHelper.isDesktop(context)
                              ? Dimensions.radiusDefault
                              : 0),
                      child: MouseRegion(
                        onEnter: (event) => _onPanStart(),
                        onExit: (event) => _onPanEnd(),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: widget.initialPosition!, zoom: 16),
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(0, 16),
                          onMapCreated:
                              (GoogleMapController mapController) async {
                            nearbyProviderController.setMapController(
                                controller: mapController);
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              nearbyProviderController.setMarker(
                                  mapController, widget.initialPosition!);
                            });
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          markers: nearbyProviderController.markers,
                          style: Get.isDarkMode
                              ? Get.find<ThemeController>().darkMap
                              : Get.find<ThemeController>().lightMap,
                          zoomGesturesEnabled:
                              nearbyProviderController.isPopupMenuOpened ==
                                  false,
                          scrollGesturesEnabled:
                              nearbyProviderController.isPopupMenuOpened ==
                                  false,
                          rotateGesturesEnabled:
                              nearbyProviderController.isPopupMenuOpened ==
                                  false,
                          tiltGesturesEnabled:
                              nearbyProviderController.isPopupMenuOpened ==
                                  false,
                        ),
                      ),
                    ),
                    GetBuilder<LocationController>(
                        builder: (locationController) {
                      String? pickedAddress;
                      if (locationController.pickAddress.address != null &&
                          locationController.pickAddress.address != "") {
                        pickedAddress = locationController.pickAddress.address;
                      } else if (nearbyProviderController
                              .selectedProviderIndex !=
                          -1) {
                        pickedAddress = nearbyProviderController
                            .providerList?[
                                nearbyProviderController.selectedProviderIndex]
                            .companyAddress;
                      } else {
                        pickedAddress = Get.find<LocationController>()
                            .getUserAddress()
                            ?.address;
                      }

                      return Positioned(
                        top: Dimensions.paddingSizeLarge,
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                        child: InkWell(
                          onTap: () => Get.dialog(
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsiveHelper.isDesktop(context)
                                        ? 0
                                        : 80,
                                    left: ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.webMaxWidth * 0.35
                                        : 0),
                                child: SizedBox(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.webMaxWidth * 0.65
                                      : Dimensions.webMaxWidth,
                                  child: LocationSearchDialog(
                                      mapController: nearbyProviderController
                                          .mapController),
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall)),
                            child: Row(children: [
                              Icon(Icons.location_on,
                                  size: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(.6)),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Expanded(
                                child: Text(
                                  pickedAddress ?? "",
                                  style: ubuntuRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Icon(Icons.search,
                                  size: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ]),
                          ),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: ResponsiveHelper.isDesktop(context) ? 20 : 180,
                      right: Dimensions.paddingSizeSmall,
                      child: FloatingActionButton(
                        hoverColor: Colors.transparent,
                        mini: true,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          nearbyProviderController.getCurrentLocation(
                              mapController:
                                  nearbyProviderController.mapController,
                              defaultLatLng: widget.initialPosition);
                        },
                        child: Icon(Icons.my_location,
                            color: Colors.white.withOpacity(0.9)),
                      ),
                    ),
                    !ResponsiveHelper.isDesktop(context)
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 170,
                              child: SingleChildScrollView(
                                controller:
                                    nearbyProviderController.scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: nearbyProviderController
                                        .providerList!
                                        .map((provider) => SizedBox(
                                              width: ResponsiveHelper.isTab(
                                                      context)
                                                  ? Get.width / 2.5
                                                  : Get.width / 1.16,
                                              child: InkWell(
                                                onTap: () async {
                                                  await nearbyProviderController
                                                      .scrollController!
                                                      .scrollToIndex(
                                                          nearbyProviderController
                                                              .providerList!
                                                              .indexOf(
                                                                  provider),
                                                          preferPosition:
                                                              AutoScrollPosition
                                                                  .middle);
                                                  await nearbyProviderController
                                                      .scrollController!
                                                      .highlight(
                                                          nearbyProviderController
                                                              .providerList!
                                                              .indexOf(
                                                                  provider));
                                                },
                                                child: AutoScrollTag(
                                                  controller:
                                                      nearbyProviderController
                                                          .scrollController!,
                                                  key: ValueKey(
                                                      nearbyProviderController
                                                          .providerList!
                                                          .indexOf(provider)),
                                                  index:
                                                      nearbyProviderController
                                                          .providerList!
                                                          .indexOf(provider),
                                                  child:
                                                      NearbyProviderMapItemView(
                                                    providerData: provider,
                                                    index:
                                                        nearbyProviderController
                                                            .providerList!
                                                            .indexOf(provider),
                                                    googleMapController:
                                                        nearbyProviderController
                                                            .mapController,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList()),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ])
          : nearbyProviderController.providerList == null
              ? const Center(child: ExploreProviderShimmerWidget())
              : const EmptyProviderWidget();
    });
  }
}

class ExploreProviderShimmerWidget extends StatelessWidget {
  const ExploreProviderShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: false,
      child: Row(
        children: [
          ResponsiveHelper.isDesktop(context)
              ? Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_back_ios_new_outlined,
                                    color: Theme.of(context).shadowColor)),
                            Container(
                              height: 25,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                              ),
                            ),
                            const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeDefault),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: Get.find<LocalizationController>().isLtr
                                    ? Dimensions.paddingSizeDefault
                                    : 0,
                                left: Get.find<LocalizationController>().isLtr
                                    ? 0
                                    : Dimensions.paddingSizeDefault,
                              ),
                              child: const ExploreProviderMapShimmer(),
                            );
                          },
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          ResponsiveHelper.isDesktop(context)
              ? const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                )
              : const SizedBox(),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                ClipRRect(
                  child: Shimmer(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.radiusDefault
                                  : 0),
                          color: Theme.of(context).shadowColor),
                    ),
                  ),
                ),
                GetBuilder<LocationController>(builder: (locationController) {
                  return Positioned(
                    top: Dimensions.paddingSizeLarge,
                    left: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall)),
                      child: Row(children: [
                        Icon(Icons.location_on,
                            size: 25, color: Theme.of(context).shadowColor),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Expanded(
                          child: Text(
                            locationController.pickAddress.address ?? "",
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Icon(Icons.search,
                            size: 25, color: Theme.of(context).shadowColor),
                      ]),
                    ),
                  );
                }),
                Positioned(
                  bottom: ResponsiveHelper.isDesktop(context) ? 20 : 180,
                  right: Dimensions.paddingSizeSmall,
                  child: FloatingActionButton(
                    hoverColor: Colors.transparent,
                    mini: true,
                    backgroundColor: !Get.isDarkMode
                        ? Theme.of(context).cardColor.withOpacity(0.7)
                        : Theme.of(context).shadowColor,
                    onPressed: null,
                    child: Icon(
                      Icons.my_location,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),
                !ResponsiveHelper.isDesktop(context)
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 170,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: [1, 2, 3, 4, 5, 6, 7]
                                    .map((provider) => SizedBox(
                                          width: ResponsiveHelper.isTab(context)
                                              ? Get.width / 2.5
                                              : Get.width / 1.16,
                                          child:
                                              const ExploreProviderMapShimmer(),
                                        ))
                                    .toList()),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreProviderMapShimmer extends StatelessWidget {
  const ExploreProviderMapShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      child: Shimmer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: Theme.of(context).hintColor.withOpacity(0.4),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          Dimensions.radiusExtraMoreLarge),
                      child: CustomImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        image: "",
                        placeholder: Images.userPlaceHolder,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).shadowColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                ),
                                const SizedBox(
                                  width: Dimensions.paddingSizeExtraLarge,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                RatingBar(
                                  rating: 5,
                                  size: 15,
                                  color: Theme.of(context).shadowColor,
                                ),
                                Gaps.horizontalGapOf(5),
                                Container(
                                  height: 13,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).shadowColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.iconLocation,
                                  height: 12,
                                  color: Theme.of(context).shadowColor,
                                ),
                                const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall,
                                ),
                                Container(
                                  height: 13,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).shadowColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                const Row(
                  children: [
                    Expanded(
                        child: ProviderInfoButton(
                      title: "",
                      subtitle: "",
                    )),
                    SizedBox(
                      width: Dimensions.paddingSizeSmall,
                    ),
                    Expanded(
                        child: ProviderInfoButton(
                      title: "",
                      subtitle: "",
                    )),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
