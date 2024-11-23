import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CreateChannelDialog extends StatefulWidget {
  final bool isSubBooking;
  const CreateChannelDialog({
    super.key,
    required this.isSubBooking,
  });

  @override
  State<CreateChannelDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<CreateChannelDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor() {
    return PointerInterceptor(
      child: GetBuilder<BookingDetailsController>(
          builder: (bookingDetailsController) {
        BookingDetailsContent? bookingDetails = widget.isSubBooking
            ? bookingDetailsController.subBookingDetailsContent
            : bookingDetailsController.bookingDetailsContent;

        ProviderData? provider = bookingDetails?.provider;
        Serviceman? serviceman = bookingDetails?.serviceman;

        return Container(
          width: Dimensions.webMaxWidth,
          margin: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.isDesktop(context)
                  ? (Dimensions.webMaxWidth) / 3
                  : 0),
          padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(20),
              topLeft: const Radius.circular(20),
              bottomLeft: ResponsiveHelper.isDesktop(context)
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              bottomRight: ResponsiveHelper.isDesktop(context)
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
            ),
          ),
          child: GetBuilder<ConversationController>(
            builder: (conversationController) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Container(
                          height: 35,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70.withOpacity(0.6),
                              boxShadow: Get.isDarkMode
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      )
                                    ]),
                          child: InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black54,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: Dimensions.paddingSizeDefault,
                          top: ResponsiveHelper.isDesktop(context)
                              ? 0
                              : Dimensions.paddingSizeDefault,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                provider != null && serviceman != null
                                    ? 'create_channel_with_provider'.tr
                                    : provider != null
                                        ? 'conversation_with_provider'.tr
                                        : serviceman != null
                                            ? 'conversation_with_serviceman'.tr
                                            : "",
                                style: ubuntuMedium,
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeLarge,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (provider != null)
                                      TextButton(
                                        onPressed: () {
                                          if (provider.chatEligibility ==
                                              true) {
                                            String name = provider.companyName!;
                                            String image =
                                                provider.logoFullPath ?? "";
                                            String phone =
                                                provider.companyPhone ?? "";
                                            Get.find<ConversationController>()
                                                .createChannel(provider.id!,
                                                    bookingDetails?.id ?? "",
                                                    name: name,
                                                    image: image,
                                                    fromBookingDetailsPage:
                                                        true,
                                                    phone: phone,
                                                    userType: "provider");
                                          } else {
                                            customSnackBar(
                                                "this_provider_have_not_permission_to_chat"
                                                    .tr,
                                                showDefaultSnackBar: false);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.3),
                                          minimumSize: const Size(
                                              Dimensions.paddingSizeLarge, 40),
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall,
                                              horizontal:
                                                  Dimensions.paddingSizeLarge),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusLarge)),
                                        ),
                                        child: Text(
                                          'provider'.tr,
                                          textAlign: TextAlign.center,
                                          style: ubuntuBold.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color),
                                        ),
                                      ),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeLarge),
                                    if (serviceman != null)
                                      TextButton(
                                        onPressed: () {
                                          String name =
                                              "${serviceman.user?.firstName ?? ""}"
                                              " ${serviceman.user?.lastName ?? ""}";
                                          String phone =
                                              serviceman.user?.phone ?? "";
                                          String image = serviceman
                                                  .user?.profileImageFullPath ??
                                              "";
                                          Get.find<ConversationController>()
                                              .createChannel(serviceman.userId!,
                                                  bookingDetails?.id ?? "",
                                                  name: name,
                                                  image: image,
                                                  fromBookingDetailsPage: true,
                                                  phone: phone);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.3),
                                          minimumSize: const Size(
                                              Dimensions.paddingSizeLarge, 40),
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall,
                                              horizontal:
                                                  Dimensions.paddingSizeLarge),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusLarge)),
                                        ),
                                        child: Text(
                                          'service_man'.tr,
                                          textAlign: TextAlign.center,
                                          style: ubuntuBold.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color),
                                        ),
                                      ),
                                  ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                            ]),
                      ),
                    ]),
              );
            },
          ),
        );
      }),
    );
  }
}
