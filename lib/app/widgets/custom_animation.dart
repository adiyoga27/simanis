part of 'widget.dart';
class SizeTransitionAnimate extends StatelessWidget {
  final Widget child;
  final int duration;
  const SizeTransitionAnimate({Key? key, required this.child, this.duration = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: duration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: child);
  }
}
