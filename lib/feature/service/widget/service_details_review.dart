import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';


class ServiceDetailsReview extends StatefulWidget {

  final String serviceID;


  const ServiceDetailsReview({super.key,required this.serviceID}) ;

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
    return  GetBuilder<ServiceTabController>(builder: (serviceTabController){
      return serviceTabController.reviewList != null && serviceTabController.reviewList!.isNotEmpty ? SingleChildScrollView(
        child: Center(
          child: WebShadowWrap(
            child: SizedBox(
              width: Dimensions.webMaxWidth,

              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  ResponsiveHelper.isDesktop(context) ? Row(crossAxisAlignment: CrossAxisAlignment.start ,children: [
                    Expanded(flex: 4, child: ReviewCardWidget(rating: serviceTabController.rating,  transparent: true)),
                    const Expanded(child: SizedBox()),
                    Expanded(flex: 4,child: ProgressCardWidget(rating: serviceTabController.rating)),
                  ]) : Column(children: [
                    ReviewCardWidget(rating: serviceTabController.rating,),
                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                      child: ProgressCardWidget(rating: serviceTabController.rating),
                    ),
                  ]),

                  const SizedBox(height: Dimensions.paddingSizeLarge,),

                  PaginatedListView(
                    scrollController: scrollController,
                    totalSize: serviceTabController.reviewContent!.reviews!.total,
                    onPaginate: (int offset) async => await  Get.find<ServiceTabController>().getServiceReview(widget.serviceID,offset, reload: false),
                    offset: serviceTabController.reviewContent!.reviews!.currentPage,
                    itemView: ListView.builder(
                      padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      itemBuilder: (context, index){
                        return ServiceReviewItem(review: serviceTabController.reviewList![index],);
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: serviceTabController.reviewList!.length,
                    ),
                  ),

                ]),
              ),
            ),
          ),
        ),
      ) : SizedBox(
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

    double fiveStar = 0.0, fourStar = 0.0, threeStar = 0.0,twoStar = 0.0, oneStar = 0.0;

    for(int i =0 ; i< rating.ratingGroupCount!.length; i++){
      if(rating.ratingGroupCount![i].reviewRating == 1){
        oneStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 2){
        twoStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 3){
        threeStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 4){
        fourStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 5){
        fiveStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
    }

    return Column(children: [
      _progressBar(
        title: 'excellent'.tr,
        colr: const Color(0xFF69B469),
        percent: fiveStar,
      ),
      _progressBar(
        title: 'good'.tr,
        colr: const Color(0xFFB0DC4B),
        percent: fourStar,
      ),
      _progressBar(
        title: 'average'.tr,
        colr: const Color(0xFFFFC700),
        percent: threeStar,
      ),
      _progressBar(
        title: 'below_average'.tr,
        colr: const Color(0xFFF7A41E),
        percent: twoStar,
      ),
      _progressBar(
        title: 'poor'.tr,
        colr: const Color(0xFFFF2828),
        percent: oneStar,
      ),
    ],);
  }
  Widget _progressBar({required String title, required double percent, required Color colr}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title.tr ,
              style: ubuntuRegular,
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(colr),
                backgroundColor: const Color(0xFFEAEAEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCardWidget extends StatelessWidget {
  final Rating rating;
  final bool transparent;
  const ReviewCardWidget({super.key, required this.rating,   this.transparent = false});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: transparent ? null : BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      child: Column(
        children: [
          if(!transparent) Align(alignment: Alignment.centerLeft, child: Text("reviews".tr, style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6),fontSize: Dimensions.fontSizeDefault))),
          if(!transparent) const Divider(),
          Text(rating.averageRating?.toStringAsFixed(2) ?? "0.0", style: ubuntuBold.copyWith(color:Theme.of(context).colorScheme.primary, fontSize: Dimensions.fontSizeForReview )),
          const SizedBox(height: Dimensions.paddingSizeTine,),
          RatingBar(rating: double.tryParse('${rating.averageRating}',), color: Theme.of(context).colorScheme.secondary, size: 20,),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${rating.ratingCount ?? ""} ${'ratings'.tr}",
              style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5), fontSize: Dimensions.fontSizeSmall),

            ),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Text(
              "${rating.reviewCount ?? ""} ${'reviews'.tr}",
              style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5), fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        ],
      ),
    );
  }
}


