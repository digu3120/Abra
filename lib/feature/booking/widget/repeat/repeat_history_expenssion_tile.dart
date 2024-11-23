
import 'package:demandium/utils/core_export.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class RepeatBookingHistoryExpansionTile extends StatefulWidget {
  const RepeatBookingHistoryExpansionTile({
    super.key,
    this.leading,
    required this.titleWidget,
    this.bookingType,
    this.subtitle,
    this.titlePadding,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.isShowExpandIcon = true,
    this.isShowTrailingExpandIcon = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.bookingTitleColor,
    this.collapsedBackgroundColor,
    this.trailingIconSize,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.controlAffinity,
  }) : assert(!initiallyExpanded),
        assert(!maintainState),
        assert(
        expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
        'CrossAxisAlignment.baseline is not supported since the expanded children '
            'are aligned in a column, not a row. Try to use another constant.',
        );

  final Widget? leading;
  final Widget titleWidget;
  final String? bookingType;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? bookingTitleColor;
  final Color? collapsedBackgroundColor;
  final double? trailingIconSize;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final bool isShowExpandIcon;
  final bool? isShowTrailingExpandIcon;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final ListTileControlAffinity? controlAffinity;

  @override
  State<RepeatBookingHistoryExpansionTile> createState() => _RepeatBookingHistoryExpansionTileState();
}

class _RepeatBookingHistoryExpansionTileState extends State<RepeatBookingHistoryExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;

  late Animation<double> _heightFactor;

  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    _isExpanded = PageStorage.of(context).readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }

    if (kDebugMode) {
      print(_backgroundColor);
      print(_heightFactor);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }


  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: (Theme.of(context).hintColor.withOpacity(0.2)), width: 0.5),
      ),
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTileTheme.merge(
          minVerticalPadding: -10,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          child: ListTile(
            onTap: null,
            leading: widget.leading,
            dense: true,
            contentPadding: widget.tilePadding ?? expansionTileTheme.tilePadding,
            title: widget.titleWidget,
            subtitle: widget.subtitle,
          ),
        ),
        ClipRect(
          child: child,
        ),
        GestureDetector(
          onTap: _handleTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Icon( _isExpanded == true ?
            Icons.keyboard_arrow_up :
            Icons.keyboard_arrow_down_rounded,
              size: widget.trailingIconSize ?? Dimensions.paddingSizeLarge,
              color: Colors.white,
            ),
          ),
        ),

      ]),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor
          ?? expansionTileTheme.collapsedTextColor
          ?? theme.textTheme.titleMedium!.color
      ..end = widget.textColor ?? expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor
          ?? expansionTileTheme.collapsedIconColor
          ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ?? expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}