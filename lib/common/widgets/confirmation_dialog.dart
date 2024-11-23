import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? icon;
  final double iconSize;
  final Icon? iconWidget;
  final String? title;
  final String? description;
  final Color? yesButtonColor;
  final Function()? onYesPressed;
  final String? noButtonText;
  final String? yesButtonText;
  final Color? noTextColor;
  final Color? yesTextColor;
  final Color? noButtonColor;
  final Widget? customButton;
  final Widget? widget;
  final Function()? onNoPressed;
  final bool isLoading;
  final double? buttonFontSize;
  const ConfirmationDialog(
      {super.key,
      this.icon,
      this.iconSize = 50,
      this.title,
      this.description,
      this.onYesPressed,
      this.onNoPressed,
      this.yesButtonColor = const Color(0xFFF24646),
      this.isLoading = false,
      this.iconWidget,
      this.noTextColor,
      this.yesTextColor,
      this.noButtonColor,
      this.noButtonText,
      this.yesButtonText,
      this.customButton,
      this.widget,
      this.buttonFontSize});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      backgroundColor: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          width: Dimensions.webMaxWidth / 2.5,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: widget ??
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: iconWidget ?? Image.asset(icon!, width: iconSize),
                  ),
                  title != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: ubuntuMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.8)),
                          ),
                        )
                      : const SizedBox(),
                  (description != null)
                      ? Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Text(
                            description!.tr,
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  customButton ??
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            Expanded(
                                child: TextButton(
                              onPressed: () => onNoPressed != null
                                  ? onNoPressed!()
                                  : Get.back(),
                              style: TextButton.styleFrom(
                                backgroundColor: noButtonColor ??
                                    Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3),
                                minimumSize:
                                    const Size(Dimensions.webMaxWidth, 45),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall)),
                              ),
                              child: Text(
                                noButtonText?.tr ?? 'no'.tr,
                                textAlign: TextAlign.center,
                                style: ubuntuMedium.copyWith(
                                  color: noTextColor ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                  fontSize: buttonFontSize ??
                                      Dimensions.fontSizeDefault,
                                ),
                              ),
                            )),
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            Expanded(
                              child: CustomButton(
                                backgroundColor: yesButtonColor,
                                textColor: yesTextColor,
                                buttonText: yesButtonText?.tr ?? 'yes'.tr,
                                onPressed: () => onYesPressed != null
                                    ? onYesPressed!()
                                    : Get.back(),
                                radius: Dimensions.radiusSmall,
                                height: 45,
                                fontSize: buttonFontSize ??
                                    Dimensions.fontSizeDefault,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                          ]),
                ]),
          )),
    );
  }
}
