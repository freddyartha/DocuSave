// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../mahas_colors.dart';
// import '../../mahas_config.dart';
// import '../../mahas_service.dart';
// import '../../models/api_list_resut_model.dart';
// import '../../services/helper.dart';
// import '../../services/http_api.dart';
// import '../inputs/input_text_component.dart';
// import '../mahas_themes.dart';
// import 'empty_component.dart';
// import 'shimmer_component.dart';

// class ListComponentController<T> {
//   Function(int index, String filter) urlApi;
//   final T Function(dynamic e) fromDynamic;
//   final bool allowSearch;
//   final bool autoRefresh;
//   final BaseUrlType baseUrlType;
//   late Function(VoidCallback fn) setState;

//   final _listViewController = ScrollController();
//   final filterController = InputTextController();
//   final List<T> _items = [];

//   ListComponentController({
//     required this.urlApi,
//     required this.fromDynamic,
//     this.allowSearch = true,
//     this.autoRefresh = true,
//     this.baseUrlType = BaseUrlType.apiDinkes,
//   });

//   bool _loadingBottom = false;
//   bool _isItemRefresh = true;
//   int _pageIndex = 0;
//   int _maxPage = 0;

//   void clear() {
//     _items.clear();
//     _pageIndex = 0;
//     _maxPage = 0;
//   }

//   Future refresh() async {
//     clear();
//     await _refreshBottom();
//     Get.focusScope?.unfocus();
//     setState(() {});
//   }

//   Future _refreshBottom({nextPage = false}) async {
//     final itemsX = await _getItems(nextPage: nextPage);
//     if (itemsX != null) {
//       if (!nextPage) _items.clear();
//       _items.addAll(itemsX);
//     }
//   }

//   Future<List<T>?> _getItems({nextPage = false}) async {
//     if (!nextPage) {
//       setState(() {
//         _isItemRefresh = true;
//       });
//     }
//     try {
//       final pageIndexX = nextPage ? _pageIndex + 1 : _pageIndex;
//       final filterX = filterController.value;
//       final query =
//           urlApi(pageIndexX + (MahasConfig.isLaravelBackend ? 1 : 0), filterX);
//       final apiModel = await HttpApi.get(
//         query,
//         baseUrlType: baseUrlType,
//       );
//       final List<T> result = [];
//       setState(() {
//         _isItemRefresh = false;
//       });
//       if (apiModel.success) {
//         ApiResultListModel listModel =
//             ApiResultListModel.fromJson(apiModel.body);
//         _maxPage = listModel.maxPage!;
//         _pageIndex = pageIndexX;
//         for (var obj in (listModel.datas ?? [])) {
//           result.add(fromDynamic(obj));
//         }
//       } else {
//         bool internetError =
//             MahasService.isInternetCausedError(apiModel.message.toString());
//         if (internetError) {
//           Helper.errorToast();
//         } else {
//           if (apiModel.message.toString().contains(RegExp(
//               "Item that you try to find can not be found",
//               caseSensitive: false))) {
//             Helper.errorToast(message: "Data tidak ditemukan");
//           } else {
//             Helper.errorToast(message: apiModel.message.toString());
//           }
//         }
//       }
//       return result;
//     } catch (ex) {
//       Helper.dialogWarning('$ex');
//       setState(() {
//         _isItemRefresh = false;
//       });
//       return null;
//     }
//   }

//   void init(Function(VoidCallback fn) setStateX) {
//     setState = setStateX;
//     filterController.onEditingComplete = () => refresh();
//     filterController.onChanged = (value) => refresh();
//     _listViewController.addListener(() async {
//       if (_loadingBottom) return;
//       final maxScroll = _listViewController.position.maxScrollExtent;
//       final currentScroll = _listViewController.position.pixels;
//       const delta = 0.0;
//       if (maxScroll - currentScroll <= delta && _pageIndex != _maxPage) {
//         _loadingBottom = true;
//         await _refreshBottom(nextPage: true);
//         _loadingBottom = false;
//       }
//     });
//     if (autoRefresh) {
//       refresh();
//     }
//   }
// }

// class ListComponent<T> extends StatefulWidget {
//   final ListComponentController<T> controller;
//   final Widget Function(T e) itemBuilder;
//   final bool allowMenuAction;
//   final List<Widget>? listMenuAction;
//   final Widget Function(BuildContext context, int index, int length)?
//       separatorBuilder;
//   final bool emptyIsCard;
//   final Widget? customEmptyWidget;
//   final bool isCustomLoadingWidget;
//   final Widget customLoadingWidget;
//   final double spaceFromHeader;
//   final String searchPlaceHolder;
//   final bool isCardSearchWithIcon;
//   final IconData searchIcon;

//   const ListComponent({
//     super.key,
//     required this.controller,
//     required this.itemBuilder,
//     this.allowMenuAction = false,
//     this.listMenuAction,
//     this.separatorBuilder,
//     this.emptyIsCard = false,
//     this.customEmptyWidget,
//     this.isCustomLoadingWidget = false,
//     this.customLoadingWidget = const ShimmerComponent(),
//     this.spaceFromHeader = 0,
//     this.searchPlaceHolder = "Search",
//     this.isCardSearchWithIcon = false,
//     this.searchIcon = Icons.search_rounded,
//   });

//   @override
//   State<ListComponent<T>> createState() => _ListComponentState<T>();
// }

// class _ListComponentState<T> extends State<ListComponent<T>> {
//   @override
//   void initState() {
//     widget.controller.init((fn) {
//       if (mounted) {
//         setState(fn);
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Visibility(
//           visible: widget.controller.allowSearch,
//           child: widget.isCardSearchWithIcon
//               ? Card(
//                   shape: MahasThemes.cardBorderShape,
//                   elevation: 5,
//                   color: MahasColors.light,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Icon(
//                           widget.searchIcon,
//                           size: 25,
//                           color: MahasColors.greyFontColor,
//                         ),
//                         Expanded(
//                           child: Center(
//                             child: InputTextComponent(
//                               edgeInsets: EdgeInsets.only(left: 5),
//                               borderRadius: Radius.zero,
//                               placeHolder: widget.searchPlaceHolder,
//                               fillColor: MahasColors.light,
//                               marginBottom: 0,
//                               controller: widget.controller.filterController,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : InputTextComponent(
//                   borderRadius: Radius.zero,
//                   placeHolder: widget.searchPlaceHolder,
//                   fillColor: MahasColors.light,
//                   marginBottom: 0,
//                   controller: widget.controller.filterController,
//                 ),
//         ),
//         SizedBox(
//           height: widget.spaceFromHeader,
//         ),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: widget.controller.refresh,
//             child: widget.controller._isItemRefresh
//                 ? widget.isCustomLoadingWidget
//                     ? widget.customLoadingWidget
//                     : const ShimmerComponent()
//                 : widget.controller._items.isEmpty &&
//                         !widget.controller._isItemRefresh
//                     ? widget.customEmptyWidget != null
//                         ? widget.customEmptyWidget!
//                         : EmptyComponent(
//                             onPressed: widget.controller.refresh,
//                             isCard: widget.emptyIsCard,
//                           )
//                     : ListView.separated(
//                         separatorBuilder: widget.separatorBuilder != null
//                             ? (context, index) => widget.separatorBuilder!(
//                                 context, index, widget.controller._items.length)
//                             : (context, index) => const Divider(height: 0),
//                         controller: widget.controller._listViewController,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: widget.controller._items.length +
//                             (MahasConfig.isLaravelBackend ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == widget.controller._items.length) {
//                             return Visibility(
//                               visible: widget.controller._pageIndex !=
//                                       widget.controller._maxPage &&
//                                   widget.controller._items.isNotEmpty,
//                               child: Container(
//                                 margin: const EdgeInsets.all(10),
//                                 child: const Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return widget
//                                 .itemBuilder(widget.controller._items[index]);
//                           }
//                         },
//                       ),
//           ),
//         )
//       ],
//     );
//   }
// }
