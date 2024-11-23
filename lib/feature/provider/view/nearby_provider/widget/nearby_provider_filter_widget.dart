import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearByFilterDialog extends StatefulWidget {
  final bool showCrossButton;
  final LatLng? initialPosition;
  const NearByFilterDialog(
      {super.key, this.showCrossButton = true, this.initialPosition});

  @override
  State<NearByFilterDialog> createState() => _NearByFilterDialogState();
}

class _NearByFilterDialogState extends State<NearByFilterDialog> {
  @override
  void initState() {
    super.initState();
    Get.find<NearbyProviderController>()
        .updatePopMenuStatus(true, shouldUpdate: false);
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.find<NearbyProviderController>().update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.find<NearbyProviderController>().updatePopMenuStatus(false);
      },
      child: GetBuilder<NearbyProviderController>(
          builder: (nearbyProviderController) {
        return Container(
          width: ResponsiveHelper.isDesktop(context)
              ? Dimensions.webMaxWidth / 2
              : Dimensions.webMaxWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge)),
          ),
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: ResponsiveHelper.isDesktop(context)
                  ? 0
                  : Dimensions.paddingSizeDefault),
          child: Column(children: [
            if (widget.showCrossButton)
              Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: Dimensions.paddingSizeLarge,
                    ),
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).hintColor.withOpacity(0.3),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeDefault
                          : 0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('sort_by'.tr,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            )),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              nearbyProviderController.sortBy.map((element) {
                            return InkWell(
                              onTap: () => nearbyProviderController
                                  .updateSortBy(element),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSeven),
                                  color: element ==
                                          nearbyProviderController
                                              .selectedSortBy
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1)
                                      : null,
                                  border: Border.all(
                                      color: element ==
                                              nearbyProviderController
                                                  .selectedSortBy
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3)
                                          : Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.2)),
                                ),
                                child: Text(
                                    element == "default"
                                        ? "${element.tr} (${'nearest'.tr})"
                                        : element.tr,
                                    style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Divider(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault),
                          child: Text(
                            'status'.tr,
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                          ),
                        ),
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 35,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                child: CustomCheckBox(
                                  title: "available",
                                  value: nearbyProviderController
                                              .providerAvailableStatus ==
                                          1
                                      ? true
                                      : false,
                                  onTap: () {
                                    nearbyProviderController
                                        .updateProviderAvailableStatus();
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 35,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                child: CustomCheckBox(
                                  title: "unavailable",
                                  value: nearbyProviderController
                                              .providerAvailableStatus ==
                                          0
                                      ? true
                                      : false,
                                  onTap: () {
                                    nearbyProviderController
                                        .updateProviderAvailableStatus();
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ]),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Divider(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault),
                          child: Text(
                            'ratings'.tr,
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                          ),
                        ),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 35,
                              child: RadioListTile(
                                visualDensity: VisualDensity.compact,
                                dense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeSmall),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                title: Text(
                                  nearbyProviderController
                                              .ratingFilter[index] ==
                                          "5"
                                      ? "only_rated_5".tr
                                      : "${nearbyProviderController.ratingFilter[index]}+ ${'rating'.tr}",
                                  style: ubuntuRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                                ),
                                value: nearbyProviderController
                                    .ratingFilter[index],
                                groupValue:
                                    nearbyProviderController.selectedRating,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                onChanged: (val) {
                                  nearbyProviderController.updateFilterByRating(
                                      nearbyProviderController
                                          .ratingFilter[index]);
                                },
                              ),
                            );
                          },
                          itemCount:
                              nearbyProviderController.ratingFilter.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeSmall,
                        ),
                        Divider(
                          color: Theme.of(context).hintColor.withOpacity(0.7),
                          height: 0.5,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeSmall),
                          child: Text(
                            'categories'.tr,
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                          ),
                        ),
                        GetBuilder<CategoryController>(
                            builder: (categoryController) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 35,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  child: CustomCheckBox(
                                    title: categoryController
                                            .categoryList?[index].name ??
                                        "",
                                    value: nearbyProviderController
                                        .categoryCheckList[index],
                                    onTap: () => nearbyProviderController
                                        .toggleFromCampaignChecked(index),
                                  ),
                                ),
                              );
                            },
                            itemCount: categoryController.categoryList?.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        }),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : 0),
              child: Row(
                children: [
                  (nearbyProviderController.isFilteredApplied())
                      ? Expanded(
                          child: CustomButton(
                            buttonText: 'clear_filter'.tr,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            textColor: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.7),
                            onPressed: () async {
                              Get.back();
                              Get.dialog(
                                const CustomLoader(),
                                barrierDismissible: false,
                              );
                              await nearbyProviderController.getProviderList(
                                  1, true,
                                  initialPosition: widget.initialPosition);
                              Get.back();
                            },
                          ),
                        )
                      : const SizedBox(),
                  (nearbyProviderController.isFilteredApplied())
                      ? const SizedBox(width: Dimensions.paddingSizeSmall)
                      : const SizedBox(),
                  Expanded(
                    child: CustomButton(
                      buttonText: 'filter'.tr,
                      onPressed: () async {
                        Get.back();
                        Get.dialog(
                          const CustomLoader(),
                          barrierDismissible: false,
                        );
                        await nearbyProviderController.getProviderList(1, true,
                            applyFilter: true,
                            initialPosition: widget.initialPosition);
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
