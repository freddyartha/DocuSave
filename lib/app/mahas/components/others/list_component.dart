import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListComponentController<T> {
  final bool allowSearch;
  final Function()? filterOnTap;
  final int pageSize;
  Query query;
  final T Function(dynamic e) fromDynamic;
  final List<T> Function(String)? searchOnType;
  late Function(VoidCallback fn) setState;

  final _listViewController = ScrollController();
  final searchCon = InputTextController();
  final List<T> _items = [];
  final List<T> _tmpItems = [];
  DocumentSnapshot? _lastDoc;

  ListComponentController({
    required this.query,
    required this.fromDynamic,
    this.pageSize = 20,
    this.allowSearch = true,
    this.searchOnType,
    this.filterOnTap,
  });

  bool _isLoading = false;
  bool _hasMore = true;
  bool _isEmpty = false;
  bool _isFilterEmpty = false;

  Future refresh() async {
    _hasMore = true;
    await fetchData();
    Get.focusScope?.unfocus();
    setState(() {});
  }

  Future<void> fetchData({bool clearAllData = true}) async {
    if (_isLoading || !_hasMore) return;
    if (clearAllData) {
      setState(() {
        _items.clear();
        _tmpItems.clear();
        _lastDoc = null;
      });
    }
    setState(() {
      if (clearAllData) _isLoading = true;
    });

    query.limit(pageSize);
    if (_lastDoc != null) {
      query.startAfterDocument(_lastDoc!);
    }
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      if (snapshot.docs.length <= pageSize) {
        _lastDoc = null;
        _hasMore = false;
      } else {
        _lastDoc = snapshot.docs.last;
        _hasMore = false;
      }
      for (var result in snapshot.docs) {
        _items.add(fromDynamic(result.data()));
      }
      _tmpItems.addAll(_items);
    } else {
      setState(() {
        _hasMore = false;
        _lastDoc = null;
        _isEmpty = true;
      });
    }

    setState(() {
      if (clearAllData) _isLoading = false;
    });
  }

  List<T> get items {
    return _tmpItems;
  }

  void init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    searchCon.onChanged = (value) {
      if (value.isNotEmpty) {
        if (searchOnType != null) {
          setState(() {
            _items.clear();
            _items.addAll(searchOnType!(value));
            if (_items.isEmpty) {
              _isFilterEmpty = true;
            } else {
              _isFilterEmpty = false;
            }
            Get.focusScope?.unfocus();
          });
        }
      } else {
        Get.focusScope?.unfocus();
        setState(() {
          _isFilterEmpty = false;
          _items.clear();
          _items.addAll(_tmpItems);
        });
      }
    };

    _listViewController.addListener(() async {
      if (_listViewController.position.pixels >=
          _listViewController.position.maxScrollExtent - 200) {
        fetchData(clearAllData: false);
      }
    });
    fetchData();
  }
}

class ListComponent<T> extends StatefulWidget {
  final ListComponentController<T> controller;
  final Widget Function(T e, int i) itemBuilder;

  const ListComponent({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  State<ListComponent<T>> createState() => _ListComponentState<T>();
}

class _ListComponentState<T> extends State<ListComponent<T>> {
  @override
  void initState() {
    widget.controller.init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller._listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller._isLoading == false &&
            widget.controller._isEmpty == true
        ? Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Image.asset("assets/images/error.png"),
              TextComponent(
                value: "general_not_found".tr,
                fontSize: MahasFontSize.h6,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        : widget.controller._isLoading == true
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ReusableWidgets.listLoadingWidget(count: 10),
        )
        : Column(
          children: [
            !widget.controller.allowSearch
                ? SizedBox.shrink()
                : Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputTextComponent(
                          controller: widget.controller.searchCon,
                          placeHolder: "Cari",
                          prefixIcon: Icon(Icons.search_outlined),
                          marginBottom: 0,
                        ),
                      ),
                      if (widget.controller.filterOnTap != null) ...[
                        GestureDetector(
                          onTap: widget.controller.filterOnTap,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                MahasRadius.regular,
                              ),
                              color: MahasColors.lightgray,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: MahasColors.darkgray,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            widget.controller._isFilterEmpty
                ? Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Image.asset("assets/images/error.png"),
                          TextComponent(
                            value: "general_not_found".tr,
                            fontSize: MahasFontSize.h6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => widget.controller.fetchData(),
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.zero,
                      controller: widget.controller._listViewController,
                      itemCount:
                          widget.controller._items.length +
                          (widget.controller._isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < widget.controller._items.length) {
                          return widget.itemBuilder(
                            widget.controller._items[index],
                            index,
                          );
                        } else {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: TextComponent(
                              value: "loading".tr,
                              fontColor: MahasColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
          ],
        );
  }
}
