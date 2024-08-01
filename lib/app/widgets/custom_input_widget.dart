part of 'widget.dart';

// class TextInputTransparent extends StatelessWidget {
//   final String? hint;
//   final TextInputType? keyboard;
//   final TextInputAction? inputAction;
//   final Function(String)? onSubmit, onChanged;
//   final bool autofocus, enabled, obsecure, showMaxLength;
//   final FocusNode? node;
//   final TextEditingController? controller;
//   final TextAlign? textAlign;
//   final int? maxLength, maxLines;
//   final List<TextInputFormatter> formatters;
//   final EdgeInsetsGeometry? contentPadding;
//   final TextStyle? textStyle, hintStyle;

//   const TextInputTransparent(
//       {Key? key,
//       this.hint,
//       this.keyboard,
//       this.inputAction,
//       this.onSubmit,
//       this.obsecure = false,
//       this.onChanged,
//       this.autofocus = false,
//       this.showMaxLength = false,
//       this.node,
//       this.controller,
//       this.textAlign,
//       this.enabled = true,
//       this.maxLength = 255,
//       this.formatters = const [],
//       this.contentPadding,
//       this.maxLines,
//       this.textStyle,
//       this.hintStyle})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Widget textField = TextField(
//       style: textStyle ?? gfont,
//       keyboardType: keyboard,
//       textInputAction: inputAction,
//       onSubmitted: onSubmit,
//       onChanged: onChanged,
//       autofocus: autofocus,
//       focusNode: node,
//       obscureText: obsecure,
//       enabled: enabled,
//       textAlign: textAlign ?? TextAlign.start,
//       controller: controller,
//       maxLines: maxLines ?? 1,
//       minLines: 1,
//       inputFormatters: [LengthLimitingTextInputFormatter(maxLength), ...formatters],
//       decoration: InputDecoration(
//         isDense: true,
//         contentPadding: contentPadding ?? Ei.sym(v: 13.5),
//         hintText: hint,
//         hintStyle: hintStyle ?? Gfont.color(Colors.black38),
//         border: InputBorder.none,
//         focusedBorder: InputBorder.none,
//         enabledBorder: InputBorder.none,
//         errorBorder: InputBorder.none,
//         disabledBorder: InputBorder.none,
//       ),
//     );

//     return textField;
//   }
// }

class TextInputGroup extends StatelessWidget {
  final List children;
  final EdgeInsetsGeometry? margin;
  final String? label;
  final IconData? icon;

  const TextInputGroup({Key? key, this.label, this.children = const [], this.margin, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? Ei.only(b: 20),
      child: Container(
        decoration: BoxDecoration(border: Br.all(), borderRadius: Br.radius(5)),
        child: Col(
          children: [
            label == null
                ? const None()
                : Container(
                    margin: Ei.only(b: 15),
                    child: Row(
                      children: [
                        icon == null ? const None() : Iconr(icon!, margin: Ei.only(r: 15)),
                        Textr(label!),
                      ],
                    ),
                  ),
            Column(
              children: List.generate(children.length, (i) {
                if (children[i] is! TextInput) {
                  return children[i];
                }

                TextInput t = children[i];

                return Column(
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(border: Br.only(['t'], except: i == 0)),
                    ),
                    TextInput(
                      key: t.key,
                      label: t.label,
                      hint: t.hint,
                      icon: t.icon,
                      keyboardType: t.keyboardType,
                      maxLength: t.maxLength,
                      onSelect: t.onSelect,
                      controller: t.controller,
                      margin: Ei.zero,
                      enabled: t.enabled,
                      suffixIcon: t.suffixIcon,
                      obsecure: t.obsecure,
                      formatters: t.formatters,
                      onChanged: t.onChanged,
                      onSubmit: t.onSubmit,
                      maxLines: t.maxLines,
                      border: Br.all(color: Colors.transparent),
                      borderRadius: children.length == 1
                          ? Br.radius(5)
                          : i == 0
                              ? TextInput.tlrRadius()
                              : i == children.length - 1
                                  ? TextInput.blrRadius()
                                  : Br.radius(0),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final bool obsecure, autofocus, enabled, badgeLimit;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLength;
  final int? maxLines;
  final FocusNode? node;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Function(TextEditingController? formControl)? onSelect;
  final Function(String)? onSubmit, onChanged;
  final Function(bool)? onFocus;
  final TextEditingController? controller;
  final List<TextInputFormatter> formatters;
  final Color? backgroundColor;

  const TextInput(
      {Key? key,
      required this.label,
      this.icon,
      this.hint,
      this.obsecure = false,
      this.autofocus = false,
      this.suffixIcon,
      this.keyboardType,
      this.maxLength = 50,
      this.maxLines,
      this.node,
      this.enabled = true,
      this.badgeLimit = false,
      this.borderRadius,
      this.border,
      this.margin,
      this.onSelect,
      this.onSubmit,
      this.onChanged,
      this.onFocus,
      this.controller,
      this.backgroundColor,
      this.formatters = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    onFocus?.call(node?.hasFocus ?? false);

    return Container(
        margin: margin ?? Ei.only(b: 15),
        child: ClipRRect(
          borderRadius: borderRadius ?? Br.radius(5),
          child: InkTouch(
            onTap: onSelect == null
                ? null
                : () {
                    if (onSelect != null) onSelect!(controller);
                  },
            color: backgroundColor ?? Colors.white,
            child: Container(
              padding: Ei.only(l: 15, r: 15, t: 15, b: 10),
              decoration: BoxDecoration(borderRadius: borderRadius ?? Br.radius(5), border: border ?? Br.all()),
              child: Col(children: [
                Container(
                  margin: Ei.only(b: 2, l: 0),
                  child: Row(
                    mainAxisAlignment: Maa.spaceBetween,
                    children: [
                      Text(label, style: Gfont.fs14),
                      badgeLimit ? TextInputBadgeLabel(controller: controller, maxLength: maxLength) : const None(),
                    ],
                  ),
                ),
                SizedBox(
                    child: Row(
                  children: [
                    Expanded(
                      child: Row(children: [
                        icon.hasNull ? const None() : Iconr(icon!, color: Colors.white38, margin: Ei.only(r: 15, b: 15)),
                        Expanded(
                            child: Focus(
                          onFocusChange: onFocus,
                          child: LzTextField(
                            hint: hint,
                            keyboard: keyboardType ?? Tit.text,
                            maxLength: maxLength,
                            node: node,
                            enabled: enabled && onSelect.hasNull,
                            obsecure: obsecure,
                            autofocus: autofocus,
                            onSubmit: onSubmit,
                            onChange: onChanged,
                            controller: controller,
                            formatters: formatters,
                            maxLines: maxLines,
                            hintStyle: const TextStyle(color: Colors.black45),
                            // textStyle: TextStyle(color: AppThemeColor.primary),
                            padding: Ei.sym(v: 5),
                          ),
                        )),
                      ]),
                    ),
                    suffixIcon ?? const None(),
                    onSelect.hasNull || !suffixIcon.hasNull
                        ? const None()
                        : const Icon(
                            La.angleDown,
                            size: 16,
                          )
                  ],
                ))
              ]),
            ),
          ),
        ));
  }

  // methods
  /// top left-right radius
  static tlrRadius([double value = 2]) => BorderRadius.only(topLeft: Radius.circular(value), topRight: Radius.circular(value));

  /// bottom left-right radius
  static blrRadius([double value = 2]) => BorderRadius.only(bottomLeft: Radius.circular(value), bottomRight: Radius.circular(value));

  static dateRangePicker(BuildContext context,
      {DateTimeRange? initialDate, DateTime? firstDate, DateTime? lastDate, String? confirmText, Function(DateTimeRange)? onSelect}) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        saveText: confirmText ?? 'Select',
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 1)),
        firstDate: firstDate ?? DateTime.now(),
        initialDateRange: initialDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(elevation: 0.5),
              colorScheme: const ColorScheme.dark(
                primary: Colors.black45, // confirm button, date background selected
                onPrimary: Colors.white, // date text color selected
                surface: Colors.white, // background header
                onSurface: Colors.black87, // date text color not selected
              ),
              dialogBackgroundColor: Colors.white, // background color
              textTheme: TextTheme(
                  headlineMedium: Gfont.fs(25), // header text
                  bodyLarge: Gfont.fs15, // list of years
                  titleMedium: Gfont.fs15, // enter date text
                  titleSmall: Gfont.fs15, // selected text
                  labelLarge: Gfont.fs15, // confirm button text
                  bodySmall: Gfont.fs15, // content text
                  bodyMedium: Gfont.color(Colors.black54)), // cancel button text
            ),
            child: child!,
          );
        });

    if (picked != null) onSelect?.call(picked);
  }

  /// ``` dart
  /// TextInput.switches(label: 'Status', initValue: true);
  /// ```
  static Widget switches(
      {String label = '', bool initValue = false, Function(bool value)? onSwitch, TextStyle? style, Alignment alignment = Alignment.centerLeft}) {
    return Touch(
      onTap: () => onSwitch?.call(!initValue),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7,
            alignment: alignment,
            child: CupertinoSwitch(value: initValue, activeColor: AppColor.primary, onChanged: onSwitch),
          ),
          Textr(label, style: style, padding: Ei.sym(v: 5))
        ],
      ),
    );
  }
}

class TextInputBadgeLabel extends StatefulWidget {
  final TextEditingController? controller;
  final int maxLength;
  const TextInputBadgeLabel({Key? key, this.controller, this.maxLength = 0}) : super(key: key);

  @override
  State<TextInputBadgeLabel> createState() => _TextInputBadgeLabelState();
}

class _TextInputBadgeLabelState extends State<TextInputBadgeLabel> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = widget.maxLength;
    String text = widget.controller?.text ?? '';
    return Text('${text.length}/$maxLength', style: Gfont.fs14);
  }
}

class RadioInput extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Function(String? value)? onChanged;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final List<String> options;

  const RadioInput(
      {Key? key, required this.label, this.borderRadius, this.margin, this.onChanged, this.controller, this.backgroundColor, this.options = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? Ei.only(b: 15),
        child: ClipRRect(
          borderRadius: borderRadius ?? Br.radius(5),
          child: Container(
            padding: Ei.only(l: 15, r: 15, t: 15, b: 10),
            width: Get.width,
            decoration: BoxDecoration(color: Colors.white, border: Br.all(color: AppColor.border), borderRadius: borderRadius ?? Br.radius(5)),
            child: Col(children: [
              Textr(label, margin: Ei.only(b: 7, l: 0), style: Gfont.fs14),
              RadioOptions(
                  initValue: controller?.text,
                  options: options,
                  onChanged: (String selected) {
                    onChanged?.call(selected);
                    controller?.text = selected;
                  })
            ]),
          ),
        ));
  }
}

class RadioOptions extends StatefulWidget {
  final String? initValue;
  final List<String> options;
  final Function(String) onChanged;
  const RadioOptions({super.key, this.initValue, this.options = const [], required this.onChanged});

  @override
  State<RadioOptions> createState() => _RadioOptionsState();
}

class _RadioOptionsState extends State<RadioOptions> {
  String selected = '';

  @override
  void initState() {
    super.initState();
    selected = widget.initValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = widget.options;

    void onChanged(String value) {
      setState(() {
        selected = value;
      });

      widget.onChanged(value);
    }

    return Wrap(
      children: List.generate(options.length, (i) {
        return InkTouch(
          onTap: () => onChanged(options[i]),
          margin: Ei.only(r: 10, b: 5),
          padding: Ei.only(r: 10),
          radius: Br.radius(15),
          child: Row(
            mainAxisSize: Mas.min,
            children: [
              Radio(
                value: options[i],
                groupValue: selected,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                onChanged: (value) => onChanged((value ?? options.first)),
              ),
              Textr(
                widget.options[i],
                margin: Ei.only(l: 10),
              )
            ],
          ),
        );
      }),
    );
  }
}