part of 'widget.dart';

class WidVersionInfo extends StatelessWidget {
  final String? title, message;
  final String cancelLabel;
  const WidVersionInfo({super.key, this.title, this.message, this.cancelLabel = 'Batal'});

  @override
  Widget build(BuildContext context) {
    String version = AppConfig.version;

    return CenterDialog(
      child: SlideUp(
        child: ClipRRect(
          borderRadius: Br.radius(5),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Container(
                  margin: Ei.sym(v: 15),
                  padding: Ei.all(15),
                  child: Column(
                    children: [
                      SvgPicture.asset('$assetImage/maintenance.svg', height: 90, width: 90),
                      Textr(
                          'Terdapat pembaruan pada aplikasi SIMANIS, versi yang Anda gunakan saat ini adalah $version, silakan perbarui aplikasi Anda.',
                          style: Gfont.muted,
                          margin: Ei.only(t: 25),
                          textAlign: Ta.center),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border(top: Br.side(Colors.black12))),
                  child: Intrinsic(
                      children: List.generate(1, (i) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border(left: Br.side(i == 0 ? Colors.transparent : Colors.black12))),
                        child: InkTouch(
                            onTap: () => Get.back(result: i == 0 ? null : i),
                            padding: Ei.all(15),
                            color: i == 0 ? Colors.black12 : Colors.white,
                            child: const Text('Perbarui Aplikasi', textAlign: Ta.center)),
                      ),
                    );
                  })),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// custom widget or component
class Component {
  static appBar(context,
      {Color? color,
      Color? titleNIconColor,
      title,
      bool center = false,
      canBack = true,
      double elevation = .5,
      double spacing = 0,
      Function? onBack,
      List<Widget> actions = const [],
      PreferredSizeWidget? bottom,
      Widget? leading}) {
    return AppBar(
      backgroundColor: color ??= Colors.white,
      title: title is String ? Text(title, style: Gfont.fs20.fcolor(titleNIconColor ?? Colors.black87)) : title,
      titleSpacing: spacing != 0
          ? spacing
          : !canBack
              ? NavigationToolbar.kMiddleSpacing
              : spacing,
      elevation: elevation,
      centerTitle: center,
      automaticallyImplyLeading: leading != null,
      leading: !canBack
          ? null
          : leading ??= IconButton(
              onPressed: () {
                if (onBack != null) {
                  onBack();
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.arrow_back, color: titleNIconColor ?? Colors.black87)),
      actions: actions,
      bottom: bottom,
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final dynamic title;
  final double maxHeight;
  final bool scrollable;
  final Widget? footer;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  const CustomBottomSheet(
      {super.key, required this.child, this.footer, this.title, this.maxHeight = 0, this.scrollable = true, this.scrollController, this.padding});

  @override
  Widget build(BuildContext context) {
    double defaultMaxheight = (Get.height - (MediaQueryData.fromView(View.of(context)).padding.top + 1));

    return ClipRRect(
      //borderRadius: BorderRadius() Br.radOnly(tl:5, tr: 5),
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: Br.radiusOnly(tl: 3, tr: 3)),
          child: Column(
            mainAxisSize: Mas.min,
            children: [
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: Mas.min,
                      children: [
                        Container(
                          margin: Ei.sym(v: 10),
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: Br.circle),
                        ),
                        title == null
                            ? const None()
                            : title is Widget
                                ? title
                                : Text('$title', style: Gfont.bold),
                        Container(
                          padding: padding,
                          margin: Ei.only(t: title == null ? 0 : 10),
                          constraints: BoxConstraints(
                              maxHeight: maxHeight == 0
                                  ? defaultMaxheight
                                  : maxHeight >= defaultMaxheight
                                      ? defaultMaxheight
                                      : maxHeight),
                          child: SingleChildScrollView(
                              controller: scrollController,
                              physics: scrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                              child: child),
                        )
                      ],
                    ),
                    Positioned.fill(child: footer ?? Container())
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class Modal {
  static Future open(Widget widget, {Function? onInit, bool dismiss = true, Function(dynamic)? then}) async {
    if (onInit != null) onInit();
    showDialog(context: Get.overlayContext!, barrierDismissible: dismiss, builder: (_) => widget).then((_) => then == null ? () {} : then(_));
  }
}

class NoData extends StatelessWidget {
  final dynamic icon;
  final String title, message, onTapLabel;
  final Function()? onTap;
  final double size;

  const NoData({super.key, this.title = '', this.message = '', this.onTap, this.onTapLabel = 'Muat ulang', required this.icon, this.size = 70});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZoomIn(
        child: Column(
          mainAxisAlignment: Maa.center,
          children: [
            icon is String
                ? icon.toString().split('.').last.toLowerCase() == 'svg'
                    ? SvgPicture.asset('assets/images/$icon', height: size, width: size)
                    : Container(
                        margin: Ei.sym(v: 15),
                        height: size,
                        width: size,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/$icon'))),
                      )
                : icon,
            GestureDetector(
              onTap: onTap == null ? null : () => onTap!(),
              child: Container(
                padding: Ei.all(20),
                decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                child: Column(
                  children: [
                    title.isEmpty ? const None() : Textr(title, style: Gfont.bold, margin: Ei.only(b: 5)),
                    Container(
                      alignment: Alignment.center,
                      child: Text(message, style: gfont.copyWith(color: Colors.black54), textAlign: Ta.center),
                    ),
                    onTap == null
                        ? const None()
                        : Container(
                            padding: Ei.all(10),
                            child: Text(onTapLabel, style: gfont.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
