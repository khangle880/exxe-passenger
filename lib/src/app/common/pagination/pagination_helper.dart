import 'package:rxdart/rxdart.dart';

class PaginationHelper<T> {
  List<T> _items = [];
  late final int limit;

  final List<Function> listeners = [];

  final PaginationConfig config = PaginationConfig();

  Future<List<T>?> Function(PaginationConfig config) asyncTask;

  Function()? onRefresh;

  BehaviorSubject<bool> bsIsLoading = BehaviorSubject.seeded(false);

  dispose() {
    _items = [];
    config.offset = 0;
    config.canLoadMore = true;
    listeners.clear();
    bsIsLoading.drain();
    bsIsLoading.close();
  }

  final bool Function(T)? shouldShow;

  PaginationHelper({
    required this.asyncTask,
    this.shouldShow,
    int? limit,
    this.onRefresh,
    List<T>? initItems,
    int? startOffset,
  }) {
    _items.addAll(initItems ?? []);
    config.offset = config.offset + (startOffset ?? 0);
    this.limit = limit ?? 20;
  }

  void addListener(Function value) {
    listeners.add(value);
  }

  void removeListener(Function value) {
    listeners.removeWhere((element) => element == value);
  }

  void updateList(List<T> newItems) {
    _items = newItems;
    callListeners();
  }

  void callListeners() {
    for (var element in listeners) {
      element.call();
    }
  }

  void addOffset(int subOffset) {
    config.offset += subOffset;
  }

  Future<void> run() {
    if (bsIsLoading.value) {
      return Future.value();
    }
    bsIsLoading.add(true);

    return asyncTask.call(config).then((value) {
      if (value != null) {
        _items.addAll(value);
      }
      for (var element in listeners) {
        element.call();
      }
      bsIsLoading.add(false);
      config.offset = config.offset + limit;
      return value;
    }).catchError((e) {
      bsIsLoading.add(false);
    });
  }

  bool get isFirstLoad =>
      _items.isEmpty && config.canLoadMore && config.offset == 0;

  bool get canLoadMore => config.canLoadMore;

  /// list all items in controller
  List<T> get canShowItems => shouldShow == null
      ? _items
      : _items.where((element) => shouldShow?.call(element) ?? true).toList();

  /// list all items can show in controller
  List<T> get items => _items;

  Future<void> refresh({bool callListener = false}) async {
    _items = [];
    config.offset = 0;
    config.canLoadMore = true;
    if (callListener) {
      callListeners();
    }
    run();
    if (onRefresh != null) {
      return onRefresh!.call();
    }
  }
}

class PaginationConfig {
  bool canLoadMore;
  int offset;

  PaginationConfig({this.canLoadMore = true, this.offset = 0});
}
