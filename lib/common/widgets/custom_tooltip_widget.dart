import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class CustomToolTip extends StatefulWidget {
  final String message;
  final Widget? child;
  final AxisDirection preferredDirection;
  final double? size;
  final Color? iconColor;
  const CustomToolTip(
      {super.key,
      required this.message,
      this.child,
      this.preferredDirection = AxisDirection.right,
      this.size,
      this.iconColor = Colors.grey});

  @override
  State<CustomToolTip> createState() => _CustomToolTipState();
}

class _CustomToolTipState extends State<CustomToolTip> {
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
      controller: tooltipController,
      preferredDirection: widget.preferredDirection,
      tailLength: 14,
      tailBaseWidth: 20,
      content: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeSmall),
        child: Text(widget.message,
            style: ubuntuRegular.copyWith(
                color: Get.isDarkMode ? Colors.black87 : Colors.white)),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          tooltipController.showTooltip();
        },
        child: widget.child ??
            Icon(Icons.info_outline,
                size: widget.size ?? 20, color: widget.iconColor),
      ),
    );
  }
}
