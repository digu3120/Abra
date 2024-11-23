import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderDetailsTopCard extends StatelessWidget {
  final String providerId;
  final Color? color;
  const ProviderDetailsTopCard(
      {super.key, required this.providerId, this.color});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (providerController) {
      ProviderData providerDetails =
          providerController.providerDetailsContent!.provider!;
      Rating? providerReview =
          providerController.providerDetailsContent?.providerRating;
      return Column(children: [
        InkWell(
          onTap: () {
            if (ResponsiveHelper.isDesktop(context)) {
              Get.dialog(Center(
                  child: ProviderAvailabilityWidget(providerId: providerId)));
            } else {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) =>
                    ProviderAvailabilityWidget(providerId: providerId),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(
                  color: color != null
                      ? Colors.transparent
                      : Theme.of(context).hintColor.withOpacity(0.15)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Stack(clipBehavior: Clip.none, children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: ResponsiveHelper.isDesktop(context) ? 15 : 0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(alignment: Alignment.bottomCenter, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusExtraMoreLarge),
                            child: CustomImage(
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                              image: providerDetails.logoFullPath ?? "",
                              placeholder: Images.userPlaceHolder,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: searchBoxShadow,
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeEight,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: providerDetails.serviceAvailability == 1
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeTine,
                              ),
                              Text(
                                providerDetails.serviceAvailability == 1
                                    ? "available".tr
                                    : "unavailable".tr,
                                style: ubuntuMedium.copyWith(
                                  color:
                                      providerDetails.serviceAvailability == 1
                                          ? Colors.green
                                          : Theme.of(context).colorScheme.error,
                                  fontSize: Dimensions.fontSizeSmall - 2,
                                ),
                              )
                            ]),
                          )
                        ]),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(providerDetails.companyName ?? '',
                                  style: ubuntuMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(
                                  height: Dimensions.paddingSizeEight),
                              Row(children: [
                                Image.asset(Images.iconLocation, height: 12),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  providerDetails.companyAddress ?? "",
                                  style: ubuntuRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.7)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ],
                          ),
                        ),
                        if (ResponsiveHelper.isDesktop(context))
                          Row(children: [
                            SizedBox(
                              width: Dimensions.webMaxWidth / 3,
                              child: _ReviewInfoCard(
                                providerReview: providerReview,
                                providerId: providerId,
                                providerDetails: providerDetails,
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraMoreLarge,
                            )
                          ]),
                      ]),
                ),
                Positioned(
                  right: Get.find<LocalizationController>().isLtr ? -20 : null,
                  left: Get.find<LocalizationController>().isLtr ? null : -20,
                  top: -20,
                  child: FavoriteIconWidget(
                    value: providerDetails.isFavorite,
                    providerId: providerDetails.id,
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              if (!ResponsiveHelper.isDesktop(context))
                _ReviewInfoCard(
                  providerReview: providerReview,
                  providerId: providerId,
                  providerDetails: providerDetails,
                ),
            ]),
          ),
        ),
      ]);
    });
  }
}

class _ReviewInfoCard extends StatelessWidget {
  final Rating? providerReview;
  final ProviderData providerDetails;
  final String providerId;
  const _ReviewInfoCard(
      {required this.providerReview,
      required this.providerId,
      required this.providerDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: searchBoxShadow,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: ResponsiveHelper.isDesktop(context)
              ? Dimensions.paddingSizeLarge
              : Dimensions.paddingSizeDefault),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const SizedBox(),
        InkWell(
          onTap: () {
            if (ResponsiveHelper.isDesktop(context)) {
              Get.dialog(Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.8),
                  child: Container(
                    width: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.webMaxWidth / 2
                        : Dimensions.webMaxWidth,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSeven),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: ProviderReviewBody(
                      providerId: providerId,
                    ),
                  ),
                ),
              ));
            } else {
              Get.toNamed(RouteHelper.getProviderReviewScreen(providerId));
            }
          },
          child: Column(children: [
            Row(children: [
              Image.asset(Images.starIcon,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 15,
                  fit: BoxFit.fitHeight),
              const SizedBox(width: Dimensions.paddingSizeTine),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  providerDetails.avgRating!.toStringAsFixed(2),
                  style: ubuntuBold.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: Dimensions.fontSizeLarge),
                ),
              ),
              Gaps.horizontalGapOf(5),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  "(${providerReview?.ratingCount ?? ""})",
                  style: ubuntuRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.6)),
                ),
              )
            ]),
            const SizedBox(height: Dimensions.paddingSizeTine),
            Text('${providerReview?.reviewCount ?? ""} ${'reviews'.tr}',
                style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ]),
        ),
        Container(
          width: 1,
          height: 30,
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(0.5),
          ),
        ),
        Column(children: [
          Text(
            '${providerDetails.totalServiceServed ?? "0"}',
            style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeTine),
          Text(
            'services_provided'.tr,
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),
        ]),
        const SizedBox(),
      ]),
    );
  }
}
