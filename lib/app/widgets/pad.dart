import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';


/// This class provides a utility for displaying a numeric keypad widget.
class LzPad {
  /// Displays the numeric keypad widget.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [title]: The title of the keypad widget.
  /// - [subtitle]: The subtitle of the keypad widget.
  /// - [header]: The header widget of the keypad widget.
  /// - [footer]: The footer widget of the keypad widget.
  /// - [length]: The length of the input.
  /// - [expired]: The duration until expiration.
  /// - [type]: The type of the keypad widget.
  /// - [style]: The style of the keypad widget.
  /// - [onCompleted]: A function called when input is completed.
  static void show(BuildContext context,
      {String? title,
      String? subtitle,
      Widget? header,
      Widget? footer,
      int length = 6,
      Duration? expired,
      PadType type = PadType.bottomLine,
      PadStyle? style,
      void Function(PadController controller)? onCompleted}) {
    context.lzFocus(); // hide keyboard
    context.bottomSheet2(
        PadWidget(
            title: title,
            subtitle: subtitle,
            header: header,
            footer: footer,
            length: length,
            expired: expired,
            type: type,
            style: style,
            onCompleted: onCompleted),
        safeArea: false);
  }
}

/// Widget for displaying the numeric keypad.
class PadWidget extends StatefulWidget {
  final String? title, subtitle;
  final Widget? header, footer;
  final int length;
  final Duration? expired;
  final PadType type;
  final PadStyle? style;
  final Function(PadController values)? onCompleted;

  const PadWidget(
      {super.key,
      this.title,
      this.subtitle,
      this.header,
      this.footer,
      this.length = 6,
      this.expired,
      this.type = PadType.bottomLine,
      this.style,
      this.onCompleted});

  @override
  State<PadWidget> createState() => _PadWidgetState();
}

class _PadWidgetState extends State<PadWidget> {
  final notifier = PadNotifier();
  late PadController valuesController;

  List<String> keyboards = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'x',
    '0',
    '<'
  ];
  Timer? timer;

  void initExpired() {
    if (widget.expired != null) {
      timer = notifier.startTimer(widget.expired!, onTimeout: () {
        timer?.cancel();
        Navigator.of(context).pop();
      });
    }

    valuesController = PadController(context, notifier, timer: timer);
  }

  @override
  void initState() {
    super.initState();

    initExpired();

    notifier.length = widget.length < 4
        ? 4
        : widget.length > 8
            ? 8
            : widget.length;

    notifier.max = notifier.length;
  }

  @override
  void dispose() {
    notifier.dispose();
    timer?.cancel();
    valuesController.timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = widget.header ??
        Column(
          children: [
            Text(widget.title ?? 'Please enter your OTP code',
                style: Gfont.bold),
            if (widget.subtitle != null)
              Textr(
                widget.subtitle!,
                textAlign: Ta.center,
                style: Gfont.muted,
                padding: Ei.all(20),
              ),
            const SizedBox(height: 25),
          ],
        );

    final style = widget.style;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        leading: IconButton(
          icon: const Icon(La.times),
          onPressed: () {
            timer?.cancel();
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: 'f1f1f1'.hex,
      body: Column(
        children: [
          Expanded(
              child: LzListView(
                shrinkWrap: true,
                padding: Ei.sym(v: 35),
                scrollLimit: const [35, 35],
                children: [
                  Column(
                    mainAxisAlignment: Maa.center,
                    children: [
                      header,
                      notifier.watch((state) => Row(
                            mainAxisSize: Mas.min,
                            children: List.generate(state.length, (i) {
                              String value = state.values.length > i
                                  ? state.values[i]
                                  : '';
                              bool isFilled = value.isNotEmpty;
                              bool inFocus = state.values.length == i;
              
                              if (widget.type == PadType.passcode) {
                                return PasscodeInput(filled: isFilled);
                              }
              
                              return Container(
                                width: (context.width - 100) / notifier.length,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: Br.radius(4),
                                  border: widget.type == PadType.bottomLine
                                      ? null
                                      : Br.all(
                                          color: isFilled
                                              ? Colors.black87
                                              : Colors.black26),
                                ),
                                padding: Ei.sym(v: 0, h: 5),
                                margin: Ei.sym(h: 3),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: value.isEmpty
                                          ? const None()
                                          : SlideUp(
                                              child: Text(value,
                                                  style: Gfont.fs20.bold)),
                                    ),
                                    if (widget.type == PadType.bottomLine)
                                      Positioned(
                                        bottom: 0,
                                        child: AnimatedContainer(
                                          duration: 150.ms,
                                          decoration: BoxDecoration(
                                            color: inFocus
                                                ? style?.bottomInline
                                                        ?.focusColor ??
                                                    Colors.black12
                                                : isFilled
                                                    ? style?.bottomInline
                                                            ?.filledColor ??
                                                        Colors.black54
                                                    : style?.bottomInline
                                                            ?.unfillColor ??
                                                        Colors.black12,
                                            borderRadius: Br.radius(4),
                                          ),
                                          width: (context.width - 160) /
                                              notifier.length,
                                          height: 2,
                                        ).lz.blink(inFocus, 300.ms),
                                      )
                                  ],
                                ),
                              );
                            }),
                          )),
                      if (widget.expired != null)
                        notifier.watch((state) {
                          return Textr('Expired in ${state.expired} seconds',
                                  style: Gfont.red, margin: Ei.only(t: 25))
                              .lz
                              .blink(!state.isPaused, 500.ms);
                        }),
                    ],
                  ),
                ],
              )),
          widget.footer ?? const None(),
          Container(
            decoration: BoxDecoration(border: Br.only(['t'])),
            child: notifier.watch((state) {
              return Wrap(
                children: keyboards.generate((item, i) {
                  bool isEmpty =
                      state.values.isEmpty && ['<', 'x'].contains(item);

                  return InkTouch(
                    onTap: isEmpty
                        ? null
                        : () {
                            if (item == 'x') {
                              notifier.reset();
                              return;
                            }

                            bool isCompleted = notifier.onInput(item);
                            if (isCompleted) {
                              valuesController.value = notifier.values.join();
                              widget.onCompleted?.call(valuesController);
                            }
                          },
                    border: Br.only([i < 3 ? '' : 't', i % 3 != 0 ? 'l' : '']),
                    color: Colors.white,
                    child: Container(
                        padding: Ei.sym(
                            h: 15, v: ['<', 'x'].contains(item) ? 16.5 : 15),
                        width: (context.width - 2) / 3,
                        child: Center(
                                child: item == '<'
                                    ? const Icon(Ti.backspace,
                                        color: Colors.black54)
                                    : item == 'x'
                                        ? const Icon(
                                            Ti.eraser,
                                            color: Colors.black54,
                                          )
                                        : Text(item, style: Gfont.fs17))
                            .lz
                            .opacity(isEmpty ? .4 : 1)),
                  );
                }),
              );
            }),
          )
        ],
      ),
    );
  }
}

/// Enumeration for the type of keypad.
enum PadType { borderRounded, bottomLine, passcode }

/// Style configuration for the keypad widget.
class PadStyle {
  final BottomInlineStyle? bottomInline;

  const PadStyle({this.bottomInline});
}

/// Style configuration for the bottom inline keypad.
class BottomInlineStyle {
  final Color? unfillColor, focusColor, filledColor;

  BottomInlineStyle({this.unfillColor, this.focusColor, this.filledColor});
}

/// Controller for managing the keypad.
class PadController {
  final BuildContext _context;
  final PadNotifier _notifier;
  Timer? timer;
  String value;

  PadController(this._context, this._notifier, {this.timer, this.value = ''});

  /// Pauses the keypad.
  PadController pause() {
    timer?.cancel();
    _notifier.isPaused = true;
    _notifier.setPaused(true);

    return this;
  }

  /// Resumes the keypad.
  PadController resume() {
    if (_notifier.remainingDuration != null) {
      _notifier.setPaused(false);
      timer = _notifier.startTimer(_notifier.remainingDuration!, onTimeout: () {
        Navigator.of(_context).pop();
      });
    }

    return this;
  }

  /// Resets the keypad.
  PadController reset() {
    _notifier.reset();
    return this;
  }
}

/// LzPadHeader widget for the keypad.
class LzPadHeader extends StatelessWidget {
  /// The icon of the keypad.
  final IconData? icon;

  /// The title and subtitle of the keypad.
  final String? title, subtitle;

  /// Creates a new LzPadHeader widget.
  const LzPadHeader({super.key, this.icon, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Iconr(icon!, size: 50, color: Colors.black54, margin: Ei.only(b: 25)),
        if (title != null) Text(title!, style: Gfont.fs18.bold),
        if (subtitle != null)
          Text(subtitle!, style: Gfont.muted, textAlign: Ta.center),
        const SizedBox(height: 20)
      ],
    );
  }
}


class PasscodeInput extends StatelessWidget {
  final bool filled;
  const PasscodeInput({super.key, this.filled = false});

  @override
  Widget build(BuildContext context) {
    double width = 25;
    double height = 25;

    return SizedBox(
      width: width + 10,
      height: height + 10,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedContainer(
              duration: 150.ms,
              width: filled ? width : 5,
              height: filled ? height : 5,
              margin: Ei.sym(h: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(filled ? .3 : 0))),
          Container(
              width: width - 10,
              height: height - 10,
              margin: Ei.sym(h: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }
}


/// This class serves as a notifier for a numeric keypad input.
class PadNotifier extends ChangeNotifier {
  /// The current length of the input.
  int length = 6;

  /// The maximum allowed length for the input.
  int max = 6;

  /// The number of expired inputs.
  int expired = 0;

  /// The remaining duration until expiration.
  Duration? remainingDuration;

  /// List of input values.
  List<String> values = [];

  /// Boolean flag indicating if the input is paused.
  bool isPaused = false;

  /// Handles the input action.
  ///
  /// Returns `true` if the input length reaches the maximum allowed length.
  bool onInput(String value) {
    if (value == '<' && values.isNotEmpty) {
      values.removeLast();
    } else {
      if (values.length < max && value != '<') {
        values.add(value);
      }
    }

    notifyListeners();

    return values.length >= max;
  }

  /// Handles the expiration event.
  void onExpired(int value) {
    expired = value;
    notifyListeners();
  }

  /// Starts a timer with the specified duration.
  ///
  /// The [onTimeout] function is called when the timer expires.
  Timer startTimer(Duration dur, {Function()? onTimeout}) {
    DateTime expired = DateTime.now().add(dur);
    Duration duration = expired.difference(DateTime.now());

    onExpired(duration.inSeconds);

    return Timer.periodic(1.s, (_) {
      Duration duration = expired.difference(DateTime.now());
      remainingDuration = duration;

      if (DateTime.now().isAfter(expired)) {
        _.cancel();
        onTimeout?.call();
      } else {
        onExpired(duration.inSeconds);
      }
    });
  }

  /// Resets the input values.
  void reset() {
    values = [];
    notifyListeners();
  }

  /// Sets the pause state of the input.
  void setPaused(bool value) {
    isPaused = value;
    notifyListeners();
  }
}


/// Extension method on [BuildContext] to provide access to Lazuli UI context modifiers.
extension LzContextModifierExtension on BuildContext {
  /// Returns an instance of [LzContextModifiers] for applying Lazuli UI context modifiers.
  ///
  /// Returns an instance of [LzContextModifiers].
  LzContextModifiers get lz => LzContextModifiers(this);
}

class LzContextModifiers {
  final BuildContext context;

  /// Constructs a [LzContextModifiers] instance with the provided build context.
  ///
  /// [context]: The build context to apply modifiers to.
  LzContextModifiers(this.context);

  void pop([dynamic result]) => Navigator.pop(context, result);
}

/// Extends the functionality of the [BuildContext] class with additional methods and properties.
extension LzContextExtension on BuildContext {
  /// Gets the height of the current screen.
  // double get height => MediaQuery.of(this).size.height;

  /// Gets the width of the current screen.
  // double get width => MediaQuery.of(this).size.width;

  /// Gets the padding of the current media.
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Gets the padding of the current view.
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  /// Gets the insets of the current view.
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Gets the padding of the current window.
  EdgeInsets get windowPadding =>
      MediaQueryData.fromView(View.of(this)).padding;

  /// Requests focus for a given [FocusNode]. If no [FocusNode] is given, a new one is created and focused.
  ///
  /// @param [node] The [FocusNode] to request focus for. Optional.
  // void lzFocus([FocusNode? node]) =>
  //     FocusScope.of(this).requestFocus(node ?? FocusNode());

  /// Pops the current route off the navigation stack and returns a result.
  ///
  /// @param [result] The result to return to the previous route. Optional.
  void lzPop([dynamic result]) => Navigator.pop(this, result);

  /// Navigate to a new screen and push the given [page] onto the navigation stack.
  ///
  /// The [page] parameter is the widget representing the new screen.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> navigateToProfile() async {
  ///   await Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
  /// }
  /// ```
  Future<T?> lzPush<T extends Object?>(Widget page) =>
      Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));

  /// Navigate to a new screen and replace the current screen with the given [page].
  ///
  /// The [page] parameter is the widget representing the new screen.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> navigateToHome() async {
  ///   await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (_) => false);
  /// }
  /// ```
  Future<T?> lzPushAndRemoveUntil<T extends Object?>(Widget page) =>
      Navigator.pushAndRemoveUntil<T>(
          this, MaterialPageRoute(builder: (_) => page), (_) => false);

  /// Navigate to a new screen with the given [routeName].
  ///
  /// The [routeName] parameter is the name of the route to navigate to.
  /// The optional [arguments] parameter is the arguments to pass to the new screen.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> navigateToDetails() async {
  ///   await Navigator.pushNamed(context, '/details', arguments: {'id': 1});
  /// }
  /// ```
  Future<T?> lzPushNamed<T extends Object?>(String routeName,
          {Object? arguments}) =>
      Navigator.pushNamed<T>(this, routeName, arguments: arguments);

  /// Navigate to a new screen with the given [routeName] and replace the current screen.
  ///
  /// The [routeName] parameter is the name of the route to navigate to.
  /// The optional [arguments] parameter is the arguments to pass to the new screen.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> navigateToLogin() async {
  ///   await Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  /// }
  /// ```
  Future<T?> lzPushNamedAndRemoveUntil<T extends Object?>(String routeName,
          {Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil<T>(this, routeName, (_) => false,
          arguments: arguments);

  /// Show a dialog on top of the current screen.
  ///
  /// The [widget] parameter is the widget representing the dialog content.
  /// The optional [dismiss] parameter specifies whether the dialog can be dismissed by tapping outside (default: true).
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> showDialog() async {
  ///   await showDialog<String>(context: context, builder: (_) => MyDialog());
  /// }
  /// ```
  Future<T?> dialog<T extends Object?>(Widget widget,
      {bool dismiss = true,
      bool backBlur = false,
      double blur = 7,
      Color? barrierColor}) {
    // If the `backBlur` flag is set, the background of the bottom sheet is blurred.
    Widget blurWrapper(Widget child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: child);

    // Show the dialog.
    return showDialog<T>(
        context: this,
        barrierDismissible: dismiss,
        barrierColor: barrierColor ?? Colors.black54,
        builder: (_) => backBlur ? blurWrapper(widget) : widget);
  }

  /// Show a general dialog on top of the current screen.
  /// This is a more customizable version of [showDialog].
  /// The [widget] parameter is the widget representing the dialog content.
  /// The optional [dismiss] parameter specifies whether the dialog can be dismissed by tapping outside (default: true).
  Future<T?> generalDialog<T extends Object?>(Widget widget,
      {bool dismiss = true,
      Duration? duration,
      double begin = .05,
      Widget Function(
              BuildContext, Animation<double>, Animation<double>, Widget)?
          transitionBuilder}) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: dismiss,
      barrierLabel: MaterialLocalizations.of(this).modalBarrierDismissLabel,
      transitionDuration: duration ?? 200.ms,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return widget;
      },
      transitionBuilder: (BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        if (transitionBuilder != null) {
          return transitionBuilder(
              buildContext, animation, secondaryAnimation, child);
        }

        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, begin),
                  end: Offset.zero,
                ).animate(animation),
                child: child));
      },
    );
  }

  /// Show a bottom sheet on top of the current screen.
  ///
  /// The [widget] parameter is the widget representing the bottom sheet content.
  /// The optional [dismiss] parameter specifies whether the bottom sheet can be dismissed by swiping (default: true).
  /// The optional [safeArea] parameter specifies whether to use safe area insets for padding (default: true).
  /// The optional [draggable] parameter specifies whether the bottom sheet can be dragged up and down (default: false).
  /// The optional [backgroundColor] parameter sets the background color of the bottom sheet.
  /// The optional [isScrollControlled] parameter specifies whether the bottom sheet should take up the entire screen height (default: true).
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> showBottomSheet() async {
  ///   await showModalBottomSheet<String>(context: context, builder: (_) => MyBottomSheet());
  /// }
  /// ```
  Future<T?> bottomSheet2<T extends Object?>(Widget widget,
      {bool dismiss = true,
      bool safeArea = true,
      bool draggable = false,
      bool backBlur = false,
      double blur = 7,
      Color? backgroundColor,
      Color? barrierColor,
      bool isScrollControlled = true}) async {
    /// Wraps a given child widget with a `Container` that provides optional padding
    /// and background color customization.
    ///
    /// This function is primarily used to wrap widgets in a consistent style, such as
    /// adding top padding to accommodate safe areas in the UI, and setting a background
    /// color.

    /// Parameters:
    ///   [child] (`Widget`) - The child widget that will be wrapped by the `Container`.
    ///
    /// Returns:
    ///   A `Container` widget wrapping the provided [child].
    ///
    /// The function applies top padding based on the `useSafeArea` flag which adjusts
    /// padding to avoid UI elements like the notch on iPhones. The background color
    /// of the container can be customized; if not specified, it defaults to white with
    /// safe area and transparent without safe area.
    Widget wrapper(Widget child) => Container(
          padding: EdgeInsets.only(
              top: safeArea
                  ? MediaQueryData.fromView(View.of(this)).padding.top
                  : 0),
          decoration: BoxDecoration(
              color: backgroundColor ??
                  (safeArea ? Colors.white : Colors.transparent)),
          child: child,
        );

    // If the `backBlur` flag is set, the background of the bottom sheet is blurred.
    Widget blurWrapper(Widget child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: child);

    // Show the bottom sheet.
    return showModalBottomSheet<T>(
      context: this,
      backgroundColor: Colors.transparent,
      isDismissible: dismiss,
      isScrollControlled: isScrollControlled,
      enableDrag: draggable,
      barrierColor: barrierColor,
      builder: ((context) => backBlur ? blurWrapper(widget) : wrapper(widget)),
    );
  }
}
