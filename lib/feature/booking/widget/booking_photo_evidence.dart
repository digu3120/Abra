import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:demandium/common/widgets/image_dialog.dart';

class BookingPhotoEvidence extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;
  const BookingPhotoEvidence({super.key, required this.bookingDetailsContent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Text(
          'completed_service_picture'.tr,
          style: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          height: 90,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: bookingDetailsContent.photoEvidenceFullPath?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (ctx) => ImageDialog(
                              imageUrl: bookingDetailsContent
                                      .photoEvidenceFullPath?[index] ??
                                  "",
                              title: "completed_service_picture".tr,
                              subTitle: "",
                            )),
                    child: CustomImage(
                      image:
                          bookingDetailsContent.photoEvidenceFullPath?[index] ??
                              "",
                      height: 70,
                      width: 120,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
