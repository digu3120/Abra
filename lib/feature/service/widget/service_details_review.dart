import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ServiceDetailsReview extends StatefulWidget {
  final String serviceID;

  const ServiceDetailsReview({super.key, required this.serviceID});

  @override
  State<ServiceDetailsReview> createState() => _ServiceDetailsReviewState();
}

class _ServiceDetailsReviewState extends State<ServiceDetailsReview> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceTabController>(builder: (serviceTabController) {
      return serviceTabController.reviewList != null &&
              serviceTabController.reviewList!.isNotEmpty
          ? SingleChildScrollView(
              child: Center(
                child: WebShadowWrap(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ResponsiveHelper.isDesktop(context)
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Expanded(
                                            flex: 4,
                                            child: ReviewCardWidget(
                                                rating:
                                                    serviceTabController.rating,
                                                transparent: true)),
                                        const Expanded(child: SizedBox()),
                                        Expanded(
                                            flex: 4,
                                            child: ProgressCardWidget(
                                                rating: serviceTabController
                                                    .rating)),
                                      ])
                                : Column(children: [
                                    ReviewCardWidget(
                                      rating: serviceTabController.rating,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeDefault),
                                      child: ProgressCardWidget(
                                          rating: serviceTabController.rating),
                                    ),
                                  ]),
                            const SizedBox(
                              height: Dimensions.paddingSizeLarge,
                            ),
                            PaginatedListView(
                              scrollController: scrollController,
                              totalSize: serviceTabController
                                  .reviewContent!.reviews!.total,
                              onPaginate: (int offset) async =>
                                  await Get.find<ServiceTabController>()
                                      .getServiceReview(
                                          widget.serviceID, offset,
                                          reload: false),
                              offset: serviceTabController
                                  .reviewContent!.reviews!.currentPage,
                              itemView: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                itemBuilder: (context, index) {
                                  return ServiceReviewItem(
                                    review:
                                        serviceTabController.reviewList![index],
                                    isProviderReview: false,
                                    index: index,
                                  );
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    serviceTabController.reviewList!.length,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              height: Get.height * 0.6,
              child: const EmptyReviewWidget(),
            );
    });
  }
}

class ProgressCardWidget extends StatelessWidget {
  final Rating rating;

  const ProgressCardWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    double fiveStar = 0.0,
        fourStar = 0.0,
        threeStar = 0.0,
        twoStar = 0.0,
        oneStar = 0.0;
    int totalFiveStar = 0,
        totalFourStar = 0,
        totalThreeStar = 0,
        totalTwoStar = 0,
        totalOneStar = 0;

    for (int i = 0; i < rating.ratingGroupCount!.length; i++) {
      if (rating.ratingGroupCount![i].reviewRating == 1) {
        oneStar =
            (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) /
                100;
        totalOneStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if (rating.ratingGroupCount![i].reviewRating == 2) {
        twoStar =
            (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) /
                100;
        totalTwoStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if (rating.ratingGroupCount![i].reviewRating == 3) {
        threeStar =
            (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) /
                100;
        totalThreeStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if (rating.ratingGroupCount![i].reviewRating == 4) {
        fourStar =
            (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) /
                100;
        totalFourStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if (rating.ratingGroupCount![i].reviewRating == 5) {
        fiveStar =
            (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) /
                100;
        totalFiveStar = rating.ratingGroupCount![i].total ?? 0;
      }
    }

    return Column(
      children: [
        _progressBar(
          title: 'excellent'.tr,
          percent: fiveStar,
          total: totalFiveStar,
        ),
        _progressBar(
          title: 'good'.tr,
          percent: fourStar,
          total: totalFourStar,
        ),
        _progressBar(
          title: 'average'.tr,
          percent: threeStar,
          total: totalThreeStar,
        ),
        _progressBar(
          title: 'below_average'.tr,
          percent: twoStar,
          total: totalTwoStar,
        ),
        _progressBar(title: 'poor'.tr, percent: oneStar, total: totalOneStar),
      ],
    );
  }

  Widget _progressBar(
      {required String title, required double percent, required int total}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title.tr,
              style: ubuntuMedium.copyWith(
                  color: Theme.of(Get.context!)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.7)),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(Get.context!).colorScheme.primary),
                backgroundColor: const Color(0xFFEAEAEA),
              ),
            ),
          ),
          const SizedBox(
            width: Dimensions.paddingSizeSmall,
          ),
          SizedBox(
            width: 25,
            height: 15,
            child: FittedBox(
                child: Text(
              "$total",
              style: ubuntuMedium,
            )),
          )
        ],
      ),
    );
  }
}

class ReviewCardWidget extends StatelessWidget {
  final Rating rating;
  final bool transparent;
  const ReviewCardWidget(
      {super.key, required this.rating, this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: transparent
          ? null
          : BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow:
                  Get.find<ThemeController>().darkTheme ? null : cardShadow,
            ),
      child: Column(
        children: [
          if (!transparent)
            Align(
                alignment: Alignment.centerLeft,
                child: Text("reviews".tr,
                    style: ubuntuMedium.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(.6),
                        fontSize: Dimensions.fontSizeDefault))),
          if (!transparent) const Divider(),
          Text(rating.averageRating?.toStringAsFixed(2) ?? "0.0",
              style: ubuntuBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Dimensions.fontSizeForReview)),
          const SizedBox(
            height: Dimensions.paddingSizeTine,
          ),
          RatingBar(
            rating: double.tryParse(
              '${rating.averageRating}',
            ),
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeExtraSmall,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${rating.ratingCount ?? ""} ${'ratings'.tr}",
              style: ubuntuMedium.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.5),
                  fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(
              width: Dimensions.paddingSizeSmall,
            ),
            Text(
              "${rating.reviewCount ?? ""} ${'reviews'.tr}",
              style: ubuntuMedium.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.5),
                  fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        ],
      ),
    );
  }
}
