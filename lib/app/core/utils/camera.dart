import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazyui/lazyui.dart' hide TextDirection;

class IDCardShapePainter extends CustomPainter {
  final double blinkOpacity;
  IDCardShapePainter(this.blinkOpacity) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final cardWidth = size.width * 0.95;
    final cardHeight = cardWidth * 0.6;
    final cardX = (size.width - cardWidth) / 2;
    final cardY = (size.height - cardHeight) / 2;

    final outerPath = Path()..addRect(Offset.zero & size);

    final innerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cardX, cardY, cardWidth, cardHeight),
      const Radius.circular(8),
    );

    final innerPath = Path()..addRRect(innerRRect);

    final combinedPath = Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(combinedPath, paint);

    // Draw text below the box
    final textColor = Color.lerp(Colors.white.withOpacity(0), Colors.white, blinkOpacity)!;

    final textSpan = TextSpan(
      text: 'Arahkan kartu identitas ke kotak',
      style: Gfont.color(textColor),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: size.width, maxWidth: size.width);
    final textOffset = Offset((size.width - textPainter.width) / 2, cardY + cardHeight + 16);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class IDCardmera extends StatefulWidget {
  const IDCardmera({super.key});

  @override
  State<IDCardmera> createState() => _IDCardmeraState();
}

class _IDCardmeraState extends State<IDCardmera> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: CameraAwesomeBuilder.custom(
              enableAudio: false,
              enablePhysicalButton: true,
              progressIndicator: LzLoader.bar(message: 'Menyiapkan kamera...'),
              aspectRatio: CameraAspectRatios.ratio_16_9,
              builder: (state, preview, rect) {
                return state.when(onPhotoMode: (state) => TakePhotoUI(state, _animationController));
              },
              previewFit: CameraPreviewFit.cover,
              saveConfig: SaveConfig.photo(pathBuilder: () => path(CaptureMode.photo)))),
    );
  }
}

class TakePhotoUI extends StatelessWidget {
  final PhotoCameraState state;
  final AnimationController animation;
  const TakePhotoUI(this.state, this.animation, {super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = CameraNotifier();

    return GestureDetector(
      onTapDown: (details) async {
        // get tap position
        // final tapPosition = details.localPosition;
        // final previewSize = await state.previewSize();

        // set focus
        // state.focusOnPoint(flutterPosition: tapPosition, pixelPreviewSize: previewSize, flutterPreviewSize: previewSize);
        state.focus();
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => CustomPaint(
                            painter: IDCardShapePainter(animation.value),
                          )),
                ),
                Poslign(
                    alignment: Alignment.bottomCenter,
                    margin: Ei.only(b: 20),
                    child: Column(
                      mainAxisSize: Mas.min,
                      children: [
                        Row(
                            mainAxisAlignment: Maa.spaceEvenly,
                            children: List.generate(3, (i) {
                              return i == 1
                                  ? InkTouch(
                                      onTap: () async {
                                        String path = await state.takePhoto();

                                        if (context.mounted) context.lzPop(path);
                                      },
                                      padding: Ei.all(5),
                                      color: Colors.white,
                                      radius: Br.radius(50),
                                      child: Container(
                                        padding: Ei.all(25),
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Br.all(color: Colors.black54, width: 2)),
                                      ),
                                    )
                                  : notifier.watch((n) => Iconr(
                                        i == 0
                                            ? La.times
                                            : n.flashMode
                                                ? La.lightbulb
                                                : La.sun,
                                        padding: Ei.all(20),
                                        color: Colors.white,
                                        size: 25,
                                      ).onTap(() {
                                        if (i == 0) {
                                          context.lzPop();
                                        } else {
                                          state.sensorConfig.setFlashMode(n.flashMode ? FlashMode.none : FlashMode.always);
                                          n.setFlashMode(!n.flashMode);
                                        }
                                      }));
                            })),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> path(CaptureMode captureMode) async {
  final Directory extDir = await getTemporaryDirectory();
  final testDir = await Directory('${extDir.path}/test').create(recursive: true);
  final String fileExtension = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
  final String filePath = '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
  return filePath;
}

class CameraNotifier extends ChangeNotifier {
  bool flashMode = false;

  void setFlashMode(bool value) {
    flashMode = value;
    notifyListeners();
  }
}
