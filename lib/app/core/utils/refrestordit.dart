import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

/// A widget that displays a refresh indicator.
class Refreshtordit extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget? child;

  /// Callback function invoked when the user triggers a refresh.
  final Function() onRefresh;

  /// The type of Refreshtor.
  final RefrehtorType type;

  /// Style configuration for the Refreshtor.
  final RefreshtorStyle? style;

  /// A builder function that returns a custom indicator widget.
  final Widget Function(IndicatorController controller, double value)? builder;

  /// Creates a Refreshtor widget.
  const Refreshtordit(
      {super.key,
      this.child,
      required this.onRefresh,
      this.type = RefrehtorType.curve,
      this.style,
      this.builder});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
        onRefresh: () async => onRefresh.call(),
        offsetToArmed: style?.offsetToArmed ?? 80,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return Stack(children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                double value = controller.value;

                if (builder != null) {
                  return builder!(controller, value);
                }

                Map<RefrehtorType, Widget> contents = {
                  RefrehtorType.curve: CurveIndicator(controller, value, style),
                  RefrehtorType.bar: BarIndicator(controller, value, style),
                  RefrehtorType.arrow: ArrowIndicator(controller, value, style)
                };

                return contents[type]!;
              },
            ),
            child
          ]);
        },
        child: child ?? const None());
  }
}


/// Style configuration for Refreshtor widget.
class RefreshtorStyle {
  /// Text displayed when the indicator is at rest.
  final String? text;

  /// Text displayed when the indicator is released.
  final String? releaseText;

  /// Text color for the indicator.
  final Color? textColor;

  /// Text color for the release state of the indicator.
  final Color? releaseTextColor;

  /// Background color for the indicator.
  final Color? backgroundColor;

  /// Color for the indicator itself.
  final Color? indicatorColor;

  /// Offset at which the indicator transitions to the armed state.
  final double? offsetToArmed;

  /// Height of the indicator.
  final double? height;

  /// Creates a RefreshtorStyle instance.
  const RefreshtorStyle({
    this.text,
    this.releaseText,
    this.textColor,
    this.releaseTextColor,
    this.backgroundColor,
    this.indicatorColor,
    this.offsetToArmed,
    this.height,
  });
}


/// Widget for displaying a curve indicator.
class CurveIndicator extends StatelessWidget {
  /// The controller for the indicator.
  final IndicatorController controller;

  /// The value of the indicator.
  final double value;

  /// The style of the indicator.
  final RefreshtorStyle? style;

  /// Creates a CurveIndicator.
  const CurveIndicator(this.controller, this.value, this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isArmed = controller.isArmed;
    bool isFinal = controller.isFinalizing;
    bool isLoading = controller.isLoading;

    Color backgroundColor = style?.backgroundColor ?? Colors.white;
    Color textColor = style?.textColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color releaseTextColor = style?.releaseTextColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color indicatorColor = style?.indicatorColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);

    String? text = style?.text;
    String? releaseText = style?.releaseText;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CustomPaint(
            painter: _CurvedShapePainter(
                value: isLoading || isFinal ? 0 : value * .4,
                color: backgroundColor),
            child: AnimatedContainer(
              duration: 150.ms,
              width: context.width,
              padding: Ei.only(t: (10 * value) + 3),
              height: isLoading || isFinal
                  ? 0
                  : 55 * value + (value * (style?.height ?? 0)),
              child: Center(
                child: AnimatedOpacity(
                    duration: 300.ms,
                    opacity: value > .4 ? 1 : 0,
                    child: Text(
                        isArmed
                            ? (releaseText ?? 'Release to refresh')
                            : (text ?? 'Pull down to refresh'),
                        style: LazyUi.font
                            .copyWith(
                                fontWeight: isArmed ? Fw.bold : Fw.normal,
                                fontSize: 12 + (1 * value))
                            .fcolor(isArmed ? releaseTextColor : textColor),
                        textAlign: Ta.center)),
              ),
            )),
        AnimatedContainer(
            duration: 100.ms,
            height: 1.2 * value,
            width: context.width * value,
            decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: Br.radius(50 * (1 - value.clamp(0, 1))))),
      ],
    );
  }
}

class _CurvedShapePainter extends CustomPainter {
  final double value;
  final Color? color;

  _CurvedShapePainter({required this.value, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height + (150 * value), size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


/// Widget for displaying a bar indicator.
class BarIndicator extends StatelessWidget {
  /// The controller for the indicator.
  final IndicatorController controller;

  /// The value of the indicator.
  final double value;

  /// The style of the indicator.
  final RefreshtorStyle? style;

  /// Creates a BarIndicator.
  const BarIndicator(this.controller, this.value, this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isArmed = controller.isArmed;
    bool isFinal = controller.isFinalizing;
    bool isLoading = controller.isLoading;

    Color backgroundColor = style?.backgroundColor ?? Colors.white;
    Color textColor = style?.textColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color releaseTextColor = style?.releaseTextColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color indicatorColor = style?.indicatorColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);

    String? text = style?.text;
    String? releaseText = style?.releaseText;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (!isLoading && !isFinal)
          SizedBox(
            width: context.width,
            child: AnimatedOpacity(
              duration: 300.ms,
              opacity: value > 1 ? 1 : value,
              child: Column(
                mainAxisSize: Mas.min,
                mainAxisAlignment: Maa.center,
                children: [
                  AnimatedContainer(
                      margin: Ei.only(t: 35 * value + (style?.height ?? 0)),
                      duration: 100.ms,
                      curve: Curves.linearToEaseOut,
                      height: 2,
                      width: 50 * value,
                      decoration: BoxDecoration(
                          color: indicatorColor.withOpacity(value.clamp(0, 1)),
                          borderRadius:
                              Br.radius(50 * (1 - value.clamp(0, 1))))),
                  ScaleSwitched(
                    alignment: Alignment.center,
                    child: value < .3
                        ? const None()
                        : Textr(
                            isArmed
                                ? (releaseText ?? 'Release to refresh')
                                : (text ?? 'Pull down to refresh'),
                            style: LazyUi.font.copyWith(
                                fontSize: 13,
                                fontWeight: isArmed ? Fw.bold : Fw.normal,
                                color: isArmed ? releaseTextColor : textColor),
                            margin: Ei.only(t: 15 * value)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget for displaying an arrow indicator.
class ArrowIndicator extends StatelessWidget {
  /// The controller for the indicator.
  final IndicatorController controller;

  /// The value of the indicator.
  final double value;

  /// The style of the indicator.
  final RefreshtorStyle? style;

  /// Creates an ArrowIndicator.
  const ArrowIndicator(this.controller, this.value, this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isArmed = controller.isArmed;
    bool isFinal = controller.isFinalizing;
    bool isLoading = controller.isLoading;

    Color backgroundColor = style?.backgroundColor ?? Colors.white;
    Color textColor = style?.textColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color releaseTextColor = style?.releaseTextColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);
    Color indicatorColor = style?.indicatorColor ??
        (backgroundColor.isDark() ? Colors.white : Colors.black87);

    String? text = style?.text;
    String? releaseText = style?.releaseText;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (!isLoading && !isFinal)
          SizedBox(
            width: context.width,
            child: AnimatedOpacity(
              duration: 300.ms,
              opacity: value > 1 ? 1 : value,
              child: Column(
                mainAxisSize: Mas.min,
                mainAxisAlignment: Maa.center,
                children: [
                  SlideSwitched(
                      direction: SlideDirection.down,
                      withOpacity: true,
                      child: value < .1
                          ? const None()
                          : Container(
                              margin:
                                  Ei.only(t: 25 * value + (style?.height ?? 0)),
                              child: ResizedSwitched(
                                show: true,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  key: ValueKey(isArmed),
                                  width: context.width,
                                  child: Iconr(
                                    isArmed ? Ti.arrowUp : Ti.arrowDown,
                                    color: indicatorColor,
                                  ).lz.blink(isArmed, 300.ms),
                                ),
                              ),
                            )),
                  AnimatedOpacity(
                    duration: 150.ms,
                    opacity: value.clamp(0, 1),
                    child: Textr(
                        isArmed
                            ? (releaseText ?? 'Release to refresh')
                            : (text ?? 'Pull down to refresh'),
                        style: LazyUi.font.copyWith(
                            fontSize: 13,
                            fontWeight: isArmed ? Fw.bold : Fw.normal,
                            color: isArmed ? releaseTextColor : textColor),
                        margin: Ei.only(t: 15 * value)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

