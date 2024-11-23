import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderReviewScreen extends StatefulWidget {
  final String? providerId;
  const ProviderReviewScreen({super.key, this.providerId});

  @override
  State<ProviderReviewScreen> createState() => _ProviderReviewScreenState();
}

class _ProviderReviewScreenState extends State<ProviderReviewScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ProviderBookingController>()
        .getProviderDetailsData(widget.providerId ?? "", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ratings_and_reviews'.tr),
      body: GetBuilder<ProviderBookingController>(
          builder: (providerBookingController) {
        return providerBookingController.providerDetailsContent == null
            ? const CircularProgressIndicator()
            : const ProviderReviewBody();
      }),
    );
  }
}

class ProviderReviewBody extends StatefulWidget {
  final String? providerId;
  const ProviderReviewBody({super.key, this.providerId});

  @override
  State<ProviderReviewBody> createState() => _ProviderReviewBodyState();
}

class _ProviderReviewBodyState extends State<ProviderReviewBody> {
  @override
  void initState() {
    super.initState();
    Get.find<ProviderBookingController>().updateProviderReviewExpendedStatus();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return GetBuilder<ProviderBookingController>(
        builder: (providerBookingController) {
      return Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ResponsiveHelper.isDesktop(context))
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child:
                          Icon(Icons.close, color: Theme.of(context).hintColor),
                    ),
                  ),
                if (ResponsiveHelper.isDesktop(context))
                  Padding(
                      padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault,
                      ),
                      child: Text(
                        'ratings_and_reviews'.tr,
                        style: ubuntuMedium.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.8),
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      )),
                ReviewRatingWidget(
                    providerBookingController: providerBookingController),
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${providerBookingController.providerDetailsContent!.providerReview?.total ?? ""} ${'reviews'.tr}",
                          style: ubuntuMedium.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.8),
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                        Container(
                          height: 0.5,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                          ),
                          margin: const EdgeInsets.only(
                              top: Dimensions.paddingSizeEight),
                        )
                      ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                providerBookingController
                                .providerDetailsContent!.providerReview !=
                            null &&
                        providerBookingController.providerDetailsContent!
                            .providerReview!.reviewList!.isNotEmpty
                    ? PaginatedListView(
                        scrollController: scrollController,
                        totalSize: providerBookingController
                            .providerDetailsContent!.providerReview!.total,
                        onPaginate: (int offset) async =>
                            await providerBookingController
                                .getProviderDetailsData(
                                    widget.providerId ?? "", true,
                                    offSet: offset),
                        offset: providerBookingController
                            .providerDetailsContent!
                            .providerReview!
                            .currentPage,
                        bottomPadding: 0,
                        itemView: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          itemBuilder: (context, index) {
                            return ServiceReviewItem(
                              review:
                                  providerBookingController.reviewList![index],
                              index: index,
                              isProviderReview: true,
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              providerBookingController.reviewList?.length,
                        ),
                      )
                    : SizedBox(
                        height: Get.height * .4,
                        child: const Center(child: EmptyReviewWidget())),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ReviewRatingWidget extends StatelessWidget {
  final ProviderBookingController providerBookingController;

  const ReviewRatingWidget(
      {super.key, required this.providerBookingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        boxShadow: searchBoxShadow,
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(children: [
            Image.asset(Images.starIcon,
                color: Theme.of(context).colorScheme.primary,
                height: 18,
                fit: BoxFit.fitHeight),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                providerBookingController
                    .providerDetailsContent!.provider!.avgRating!
                    .toStringAsFixed(2),
                style: ubuntuBold.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Dimensions.fontSizeLarge),
              ),
            ),
            Text(
              " / 5",
              style: ubuntuMedium.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
          ]),
          Container(
            height: 15,
            width: 0.5,
            color: Theme.of(context).hintColor,
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
          ),
          Text(
            "${providerBookingController.providerDetailsContent!.provider!.ratingCount ?? ""} ${'ratings'.tr}",
            style: ubuntuMedium.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        ProgressCardWidget(
            rating: providerBookingController
                    .providerDetailsContent!.providerRating ??
                Rating(
                    ratingCount: 0,
                    averageRating: 4.0,
                    reviewCount: 0,
                    ratingGroupCount: [])),
      ]),
    );
  }
}
