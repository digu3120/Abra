import 'package:demandium/common/widgets/ldashed_line_printer.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ServiceReviewItem extends StatelessWidget {
  final Review review;
  const ServiceReviewItem({super.key, required this.review}) ;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
            child: CustomImage(
              image: review.customer?.profileImageFullPath ??"",
              height: 40, width: 40,
              placeholder: Images.userPlaceHolder,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text( review.customer == null ? "customer_not_available".tr : "${review.customer?.firstName ?? ""} ${review.customer?.lastName ?? ""}",
                    style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.9)),
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                Row( children: [
                  RatingBar(rating: review.reviewRating!.toDouble(), color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                  Text(review.reviewRating!.toStringAsFixed(1),
                    style: ubuntuMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall,),

          Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.updatedAt!)),
            style: ubuntuRegular.copyWith(color:  Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall + 1),
            textDirection: TextDirection.ltr,
          ),

        ],
      ),

      Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeEight, top: Dimensions.paddingSizeDefault),
        child: ReadMoreText(
          review.reviewComment ?? "",
          trimCollapsedText : "see_more".tr,
          trimExpandedText: "  ${"see_less".tr}",
          trimMode: TrimMode.Line,
          trimLines: 3,
          style: ubuntuRegular.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            fontSize: Dimensions.fontSizeSmall,
            height: 1.5
          ),
          textAlign: TextAlign.justify,
          moreStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
          lessStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),

      if(review.reviewReply !=null) Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
        CustomPaint(
          size: const Size(15, 50), // Adjust size as needed
          painter: LDashedLinePainter(),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 0.5),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: Row(children: [
                      Image.asset(Images.reviewReply, width: 25,),
                      const SizedBox(width: Dimensions.paddingSizeEight,),
                      ResponsiveHelper.isDesktop(context) ? Text("replied_by_provider".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis,) :  Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("replied_by_provider".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis,),
                            review.provider != null && !ResponsiveHelper.isDesktop(context) ? TextButton(
                              onPressed: (){
                                Get.toNamed(RouteHelper.getProviderDetails(review.provider!.id!));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(60,20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    
                              ),
                              child: Text(review.provider?.companyName ?? "", style: ubuntuRegular.copyWith(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Dimensions.fontSizeSmall,
                              ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ) : const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                      review.provider != null && ResponsiveHelper.isDesktop(context) ? TextButton(
                        onPressed: (){
                          Get.toNamed(RouteHelper.getProviderDetails(review.provider!.id!));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50,30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    
                        ),
                        child: Row(
                          children: [
                            const Text(" - "),
                            Text(review.provider?.companyName ?? "", style: ubuntuRegular.copyWith(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Dimensions.fontSizeSmall,
                            )),
                          ],
                        ),
                      ) : const SizedBox()
                    
                    ]),
                  ),
                  Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.reviewReply!.updatedAt!)),
                    style: ubuntuRegular.copyWith(color:  Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall + 1),
                    textDirection: TextDirection.ltr,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                ReadMoreText(
                  review.reviewReply?.reply ?? "",
                  trimCollapsedText : "see_more".tr,
                  trimExpandedText: "  ${"see_less".tr}",
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  style: ubuntuRegular.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontSize: Dimensions.fontSizeSmall,
                    height: 1.5
                  ),
                  textAlign: TextAlign.justify,
                  moreStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                  lessStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        )
      ],),
      const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
    ]);
  }
}
