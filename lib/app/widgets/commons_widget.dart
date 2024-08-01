part of 'widget.dart';

class DateTimeCountDown extends StatelessWidget {
  final DateTime expiredTime;
  final double fontSize;
  const DateTimeCountDown(this.expiredTime, {super.key, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(1.s, (i) => i),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          int now = DateTime.now().millisecondsSinceEpoch;
          Duration duration = Duration(milliseconds: expiredTime.millisecondsSinceEpoch - now);

          // int d = duration.inDays.remainder(60);
          int h = duration.inHours.remainder(60);
          int m = duration.inMinutes.remainder(60);
          int s = duration.inSeconds.remainder(60);

          return Row(
              mainAxisSize: Mas.min,
              children: List.generate(3, (i) {
                List<String> labels = [' Jam ', ' Menit ', ' Detik '], values = duration.inSeconds <= 0 ? ['0', '0', '0'] : ['$h', '$m', '$s'];

                return Container(
                  margin: Ei.only(r: i == 2 ? 0 : 10),
                  child: Column(
                    children: [
                      Textr(values[i] + labels[i], style: gfont.copyWith(color: Colors.red, fontSize: fontSize)),
                    ],
                  ),
                );
              }));
        });
  }
}

class CustomWebView extends StatelessWidget {
  final String url;
  final Map<String, String>? headers;
  final Function(InAppWebViewController)? onWebViewCreated;
  final Function(InAppWebViewController controller, int progress)? onProgressChanged;

  const CustomWebView({Key? key, required this.url, this.headers, this.onWebViewCreated, this.onProgressChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(transparentBackground: true, supportZoom: false, preferredContentMode: UserPreferredContentMode.MOBILE)),
      initialUrlRequest: URLRequest(url: Uri.parse(url), headers: headers),
      onWebViewCreated: onWebViewCreated,
      onProgressChanged: onProgressChanged,
    );
  }

  static Future<bool> goBack(InAppWebViewController? controller) async {
    if (controller == null) {
      Get.back();
      return Future.value(false);
    }

    bool canGoBack = await controller.canGoBack();

    if (canGoBack) {
      controller.goBack();
      return Future.value(false);
    } else {
      Get.back();
    }

    return Future.value(true);
  }
}

/* ------------------------------------------------------------------------
| Mixins Dropdown
| ------------------------------------------------------- */

// class MixinsDropdown extends StatelessWidget {
//   const MixinsDropdown({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   static open(BuildContext context,
//       {List<String> options = const [],
//       List<IconData> icons = const [],
//       List<int> dangers = const [],
//       List<int> disableds = const [],
//       Offset? offset,
//       Function(String value, int index)? onSelect}) {
//     if (options.isEmpty) return;

//     final RenderBox? box = context.findRenderObject() as RenderBox?;
//     final Offset? o = box?.localToGlobal(Offset.zero);
//     double dy = o?.dy ?? 0;

//     // get height of widget by context
//     double itemHeight = box?.size.height ?? 0;
//     dy += itemHeight;

//     Get.dialog(DropdownPositioned(
//         offset: offset ?? Offset(20, dy),
//         options: options,
//         dangers: dangers,
//         icons: icons,
//         itemHeight: itemHeight,
//         onSelect: onSelect,
//         disabled: disableds));
//   }

//   static selector(GlobalKey key,
//       {List<String> options = const [],
//       List values = const [],
//       String? initValue,
//       List<int> dangers = const [],
//       List<int> disableds = const [],
//       ConfigSelector? config,
//       Offset? offset,
//       Function(String option, dynamic value)? onSelect}) {
//     if (options.isEmpty) return;

//     final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
//     final Offset? o = box?.localToGlobal(Offset.zero);

//     double dy = o?.dy ?? 0;
//     double dx = o?.dx ?? 0;

//     Get.dialog(DropdownSelector(
//         offset: Offset(dx, dy), initValue: initValue, options: options, values: values, dangers: dangers, onSelect: onSelect, disabled: disableds));
//   }
// }

// class DropdownSelector extends StatelessWidget {
//   final Offset offset;
//   final List<String> options;
//   final List values;
//   final String? initValue;
//   final List<int> dangers, disabled;
//   final Function(String option, dynamic value)? onSelect;
//   const DropdownSelector(
//       {super.key,
//       required this.offset,
//       this.options = const [],
//       this.values = const [],
//       this.initValue,
//       this.onSelect,
//       this.dangers = const [],
//       this.disabled = const []});

//   @override
//   Widget build(BuildContext context) {
//     // check if dropdown is out of screen
//     double optionHeight = (options.length * 47) + 50; // 50 = height of bottom navigation bar
//     // double pos = offset.dy + optionHeight;

//     // double remainder = Get.height - pos;
//     bool isOutOfScreen = offset.dy + optionHeight > Get.height;

//     Widget caret = RotationTransition(
//       turns: const AlwaysStoppedAnimation(0),
//       child: CustomPaint(
//         painter: TrianglePainter(
//           strokeColor: Colors.white,
//           strokeWidth: 3,
//           paintingStyle: PaintingStyle.fill,
//         ),
//         child: const SizedBox(
//           height: 11,
//           width: 15,
//         ),
//       ),
//     );

//     double itemHeight = Get.height * 0.4;
//     int io = options.indexOf(initValue ?? '');

//     return Stack(
//       children: [
//         Positioned(
//           top: (offset.dy + 35),
//           right: offset.dx,
//           child: SlideUp(
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 0,
//                   right: 16,
//                   child: SlideUp(delay: 150, child: caret),
//                 ),
//                 Container(
//                   margin: Ei.only(t: 10),
//                   child: ClipRRect(
//                     borderRadius: Br.radius(5),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       color: Colors.white,
//                       constraints: BoxConstraints(maxHeight: itemHeight, maxWidth: 250),
//                       child: SingleChildScrollView(
//                         physics: BounceScroll(),
//                         padding: Ei.sym(v: 5),
//                         child: IntrinsicWidth(
//                           child: Col(
//                             children: List.generate(options.length, (i) {
//                               bool isAcitve = (io < 0 ? 0 : io) == i;

//                               return SlideLeft(
//                                 delay: isOutOfScreen ? ((3 - i) * 50) : (i + 1) * 50,
//                                 child: InkTouch(
//                                   onTap: disabled.contains(i)
//                                       ? null
//                                       : () {
//                                           Get.back();

//                                           String option = options[i];
//                                           String value = values.length > i ? values[i] : '';

//                                           onSelect?.call(option, value);
//                                         },
//                                   color: isAcitve ? Utils.hex('f5f5f5') : Colors.white,
//                                   child: Container(
//                                     padding: Ei.sym(v: 15, h: 20),
//                                     constraints: const BoxConstraints(minWidth: 200),
//                                     child: Opacity(
//                                       opacity: disabled.contains(i) ? .5 : 1,
//                                       child: Row(
//                                         children: [
//                                           Flexible(
//                                             child: Textr(
//                                               options[i],
//                                               style: Gfont.fs16.copyWith(color: dangers.contains(i) ? Colors.redAccent : Colors.black54),
//                                               padding: Ei.only(r: 10),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ConfigSelector {
  final Future request;
  final String? option;
  final dynamic value;

  ConfigSelector({required this.request, this.option, this.value});
}

/// ``` dart
/// PhotoViewer.open('https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png');
/// ```

class PhotoViewer extends StatelessWidget {
  final String image;
  const PhotoViewer({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
              minScale: PhotoViewComputedScale.contained,
              maxScale: 1.0,
              imageProvider: NetworkImage(image),
              loadingBuilder: (context, data) {
                return data == null ? const None() : Center(child: LzLoader.bar(message: 'Loading image...'));
              }),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Touch(
                onTap: () => Get.back(),
                child: SlideUp(
                  delay: 250,
                  child: Container(
                    margin: Ei.all(20),
                    decoration: BoxDecoration(border: Br.all(color: Colors.white), borderRadius: Br.radius(50)),
                    child: Iconr(
                      La.times,
                      color: Colors.white,
                      padding: Ei.all(15),
                    ),
                  ),
                )),
          ))
        ],
      ),
    );
  }

  static open(String? image) {
    if (image == null) return Toasts.show('Image not found');
    Helpers.bottomSheet(PhotoViewer(image: image));
  }
}


/// shortcut of Column with `mainAxisAlignment: MainAxisAlignment.start`
class Col extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const Col(
      {Key? key,
      this.children = const <Widget>[],
      this.mainAxisAlignment = Maa.start,
      this.mainAxisSize = Mas.min})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: Caa.start,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }
}

/* --------------------------------------------------------------------------
| LzBadge
| ---------------------------------------------------------------------------
| LzBadge is a widget to show a badge with text
| */

class LzBadge extends StatelessWidget {
  final String text;
  final Color? color, textColor;
  final BorderRadiusGeometry? radius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final BoxBorder? border;
  const LzBadge(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.radius,
      this.padding,
      this.fontSize,
      this.border});

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Colors.orange;

    return Container(
      decoration: BoxDecoration(
          color: color.withOpacity(.15),
          borderRadius: radius ?? Br.radius(3),
          border: border ?? Br.all(color: color)),
      padding: padding ?? Ei.sym(v: 3, h: 10),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: textColor ?? color, fontSize: fontSize)),
    );
  }
}

/* --------------------------------------------------------------------------
| LzBox
| ---------------------------------------------------------------------------
| LzBox is a shortcut of `Container` with some additional features
| */

enum BoxType { customize, clean }

class LzBox extends StatelessWidget {
  final Widget? child;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding, margin;
  final BoxBorder? border;
  final Color? color;
  final BorderRadiusGeometry? radius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;
  final BoxConstraints? constraints;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final BoxType type;

  const LzBox(
      {super.key,
      this.child,
      this.children = const [],
      this.padding,
      this.margin,
      this.border,
      this.color,
      this.radius,
      this.boxShadow,
      this.gradient,
      this.shape = BoxShape.rectangle,
      this.constraints,
      this.crossAxisAlignment,
      this.mainAxisSize = Mas.min,
      this.mainAxisAlignment = Maa.start,
      this.type = BoxType.customize});

  @override
  Widget build(BuildContext context) {
    bool isCleanType = type == BoxType.clean;

    double spacing = isCleanType ? 0 : LazyUi.space;
    double radius = isCleanType ? 0 : LazyUi.space;

    return Container(
      padding: padding ?? Ei.all(spacing),
      margin: margin,
      constraints: constraints,
      decoration: BoxDecoration(
          border: border ?? (isCleanType ? Br.none : Br.all()),
          color: color ?? Colors.white,
          borderRadius: this.radius ?? Br.radius(radius),
          boxShadow: boxShadow,
          gradient: gradient,
          shape: shape),
      child: ClipRRect(
          borderRadius: this.radius ?? Br.radius(radius),
          child: child ??
              Column(
                  mainAxisSize: mainAxisSize,
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment ??
                      (isCleanType ? Caa.center : Caa.start),
                  children: children)),
    );
  }

  static Widget clean(
      {Widget? child,
      List<Widget> children = const [],
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      CrossAxisAlignment? crossAxisAlignment,
      MainAxisSize mainAxisSize = Mas.min,
      MainAxisAlignment mainAxisAlignment = Maa.start,
      BoxConstraints? constraints,
      BoxShape shape = BoxShape.rectangle,
      BoxBorder? border,
      Color? color,
      BorderRadiusGeometry? radius,
      List<BoxShadow>? boxShadow,
      Gradient? gradient}) {
    return LzBox(
      child: child,
      children: children,
      padding: padding,
      margin: margin,
      type: BoxType.clean,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      constraints: constraints,
      shape: shape,
      border: border,
      color: color,
      radius: radius,
      boxShadow: boxShadow,
      gradient: gradient,
    );
  }
}

/* --------------------------------------------------------------------------
| LzPopover
| ---------------------------------------------------------------------------
| LzPopover is a widget that displays a pop-up window
| */

class LzPopover extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? width, maxWidth;
  final double minWidth;
  final Offset offset;
  final BorderRadiusGeometry? radius;
  final BoxBorder? border;
  final Position? caretAlign;
  const LzPopover(
      {super.key,
      this.child,
      this.color,
      this.width = 250,
      this.minWidth = 250,
      this.maxWidth,
      this.offset = const Offset(.5, 0),
      this.radius,
      this.border,
      this.caretAlign});

  @override
  Widget build(BuildContext context) {
    double x = (width ?? 250) *
        (offset.dx > 1
            ? 1
            : offset.dx < 0
                ? 0
                : offset.dx);

    x = (x - 10) <= 15
        ? x + 15
        : x >= (width ?? 250)
            ? x - 35
            : x - 10;

    Color color = this.color ?? Colors.white;
    bool isTop = caretAlign == Position.top;

    double radius = LazyUi.radius;

    return Stack(children: [
      Container(
        padding: Ei.all(20),
        margin: Ei.only(b: isTop ? 0 : 10, t: isTop ? 10 : 0),
        width: width,
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth ?? Get.width,
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: this.radius ?? Br.radius(radius),
            border: border ?? Br.all()),
        child: child,
      ),
      Positioned(
          left: x,
          bottom: isTop ? null : offset.dy,
          top: !isTop ? null : offset.dy,
          child: RotationTransition(
            turns: AlwaysStoppedAnimation(isTop ? 180 : 180 / 360),
            child: CustomPaint(
              painter: CaretPainter(
                  strokeColor: color,
                  paintingStyle: PaintingStyle.fill,
                  skew: 2),
              child: const SizedBox(
                height: 10,
                width: 20,
              ),
            ),
          ))
    ]);
  }

  void show(BuildContext context,
      {Offset offset = const Offset(20, 0),
      bool isAtBottom = false,
      Widget Function(Widget child)? builder}) {
    final box = context.findRenderObject() as RenderBox?;
    final o = box?.localToGlobal(Offset.zero);

    // get x and y values
    double dx = o?.dx ?? 0;
    double dy = o?.dy ?? 0;

    // get width and height context
    double height = box?.size.height ?? 0;

    double popoverWidth = width ?? 250;

    dx = (dx > (Get.width - popoverWidth)
        ? (Get.width - popoverWidth) - offset.dx
        : dx < 0
            ? (0 + offset.dx)
            : dx);

    if (isAtBottom) {
      dy = dy + height + offset.dy;
    }

    context.dialog(Stack(
      children: [
        Positioned(
          left: dx,
          top: dy,
          child: builder?.call(this) ?? this,
        )
      ],
    ));
  }
}

class CustomDialog extends StatelessWidget {
  final BorderRadiusGeometry? radius;
  final List<Widget> children;
  final Widget? footer;
  final Color? color;
  final Gradient? gradientColor;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? alignment;
  final bool showXIcon, showTapClose;
  final String? closeMessage;

  const CustomDialog(
      {super.key,
      this.radius,
      this.children = const [],
      this.footer,
      this.color,
      this.gradientColor,
      this.padding,
      this.alignment,
      this.showXIcon = false,
      this.showTapClose = false,
      this.closeMessage});

  @override
  Widget build(BuildContext context) {
    double radius = LazyUi.radius;

    return CenterDialog2(
        showTapClose: showTapClose,
        closeMessage: closeMessage,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              constraints: BoxConstraints(
                  maxHeight:
                      (Get.height * .7) - (context.viewInsets.bottom / 2)),
              decoration: BoxDecoration(
                  gradient: gradientColor,
                  color: color ?? Colors.white,
                  borderRadius: this.radius ?? Br.radius(radius)),
              child: Column(
                mainAxisSize: Mas.min,
                crossAxisAlignment: alignment ?? Caa.center,
                children: [
                  SingleChildScrollView(
                    physics: BounceScroll(),
                    padding: padding ?? Ei.all(20),
                    child: Column(
                      crossAxisAlignment: alignment ?? Caa.center,
                      children: children,
                    ),
                  ),
                  footer ?? const None(),
                ],
              ),
            ),
            if (showXIcon)
              Poslign(
                alignment: Alignment.topRight,
                child: Container(
                  padding: Ei.all(20),
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: Utils.hex('fff'),
                        spreadRadius: 25,
                        blurRadius: 25,
                        offset: const Offset(0, -7)),
                  ]),
                  child: const Icon(La.times),
                ).onTap(() => Get.back()),
              )
          ],
        ).lz.clip(all: 7));
  }
}

/// ``` dart
/// CenterDialog2( // use it on showDialog
///   child: // your widget
/// )
/// ```
class CenterDialog2 extends StatelessWidget {
  final Widget child;
  final double margin;
  final BorderRadiusGeometry borderRadius;
  final String? closeMessage;
  final bool showTapClose;

  const CenterDialog2(
      {Key? key,
      required this.child,
      this.margin = 15,
      this.borderRadius = BorderRadius.zero,
      this.closeMessage,
      this.showTapClose = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: Maa.center,
      children: [
        Container(
          padding: Ei.only(b: context.viewInsets.bottom),
          child: Material(
              color: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(margin),
                  child: ClipRRect(borderRadius: borderRadius, child: child))),
        ),
        if (showTapClose)
          IgnorePointer(
              child: Text(closeMessage ?? 'Tap to close',
                  style: Gfont.white))
      ],
    );
  }
}