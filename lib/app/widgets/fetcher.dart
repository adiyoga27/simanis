part of 'widget.dart';

class FetcherController<T> {
  final Function() refresh;
  final T? data;

  FetcherController({
    required this.refresh,
    this.data,
  });
}

typedef OnLoading = Widget Function();

/// ```dart
///
/// Future<List<ItemModel>> getItems() async {
///   // do something
/// }
///
/// body: Fetcher(
///   onInit: () => getItems(),
///   onLoading: LzLoader.bar(message: 'Loading data items...'),
///   onData: (List<ItemModel> items) {
///     // do something
///   },
/// )
/// ```
///
///
class Fetcher<T> extends StatefulWidget {
  final Future<T?> Function()? onInit;
  final Widget Function(FetcherController<T> controller) onData;
  final OnLoading onLoading;

  const Fetcher({
    Key? key,
    required this.onInit,
    required this.onData,
    required this.onLoading,
  }) : super(key: key);

  @override
  State<Fetcher<T>> createState() => _FetcherState<T>();
}

class _FetcherState<T> extends State<Fetcher<T>> {
  RxBool isLoading = true.obs;
  T? _data;

  Future fetch() async {
    isLoading.value = true;

    widget.onInit?.call().then((value) {
      _data = value;
      isLoading.value = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  // @override
  // void didUpdateWidget(Fetcher<T> oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.future != oldWidget.future) {
  //     setState(() {
  //       _future = widget.future;
  //       _data = null;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = this.isLoading.value;
      return isLoading
          ? widget.onLoading()
          : widget.onData(FetcherController(
              refresh: fetch,
              data: _data,
            ));
    });
  }
}
