import 'dart:math';
import 'package:demandium/utils/core_export.dart';


abstract class AnimationControllerState<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState();
  late final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}



class CustomShakingWidget extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;
  const CustomShakingWidget({
    super.key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 2,
    this.shakeDuration = const Duration(milliseconds: 400),
  });

  @override
  CustomShakingWidgetState createState() => CustomShakingWidgetState();
}

class CustomShakingWidgetState extends AnimationControllerState<CustomShakingWidget> {
  CustomShakingWidgetState();

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue = sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}

