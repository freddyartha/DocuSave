import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/models/service_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ServiceListController extends GetxController {
  final searchCon = InputTextController();
  late ListComponentController<ServiceModel> listCon;
  final defaultQuery = FirebaseRepository.getToServiceCollection.orderBy(
    'createdAt',
    descending: true,
  );
  // final List<ItemValueModel> filterList = [
  //   ItemValueModel(item: "store_name".tr, value: false.obs),
  //   ItemValueModel(item: "currency".tr, value: false.obs),
  //   ItemValueModel(item: "category".tr, value: false.obs),
  //   ItemValueModel(item: "payment_method".tr, value: false.obs),
  // ];

  @override
  void onInit() {
    listCon = ListComponentController(
      query: defaultQuery,
      fromDynamic: ServiceModel.fromDynamic,
      searchOnType: (value) {
        return [];
        // return listCon.items.where((e) {
        //   final store = e.storename.toLowerCase();
        //   final category = e.category;
        //   final currency = e.currency.toLowerCase();
        //   final paymentmethod = e.paymentmethod;

        //   final notes = e.notes.toString().toLowerCase();
        //   final query = value.toLowerCase();

        //   return store.contains(query) ||
        //       category.toString() == query ||
        //       currency.contains(query) ||
        //       paymentmethod.toString() == query ||
        //       notes.contains(query);
        // }).toList();
      },
      // filterOnTap: () async {
      //   Query filterQuery = listCon.query;
      //   bool? result = await ReusableWidgets.confirmationBottomSheet(
      //     title: "Urutkan Berdasarkan",
      //     children: [
      //       StatefulBuilder(
      //         builder: (BuildContext context, StateSetter setState) {
      //           return Wrap(
      //             runSpacing: 10,
      //             spacing: 10,
      //             alignment: WrapAlignment.center,
      //             children: List.generate(filterList.length, (i) {
      //               var item = filterList[i];
      //               RxBool selectedValue = item.value as RxBool;
      //               return GestureDetector(
      //                 onTap: () {
      //                   setState(() {
      //                     selectedValue.toggle();
      //                   });
      //                 },
      //                 child: Container(
      //                   width: Get.width / 3.5,
      //                   decoration: BoxDecoration(
      //                     color:
      //                         selectedValue.value == true
      //                             ? MahasColors.primary
      //                             : null,
      //                     border: Border.all(
      //                       color:
      //                           selectedValue.value == true
      //                               ? MahasColors.primary
      //                               : MahasColors.mutedGrey,
      //                     ),
      //                     borderRadius: BorderRadius.circular(
      //                       MahasRadius.large,
      //                     ),
      //                   ),
      //                   constraints: BoxConstraints(minHeight: 45),
      //                   child: Container(
      //                     padding: EdgeInsets.all(10),
      //                     alignment: Alignment.center,
      //                     child: TextComponent(
      //                       value: item.item,
      //                       height: 1,
      //                       fontSize: MahasFontSize.small,
      //                       fontColor:
      //                           selectedValue.value == true
      //                               ? MahasColors.white
      //                               : MahasColors.mutedGrey,
      //                       fontWeight: FontWeight.w500,
      //                       textAlign: TextAlign.center,
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             }),
      //           );
      //         },
      //       ),
      //     ],
      //   );

      //   if (result == true) {
      //     for (var f in filterList) {
      //       if (f.value == true) {
      //         String orderString = InputFormatter.titleToCamelCase(f.item);
      //         filterQuery = filterQuery.orderBy(orderString);
      //       }
      //     }
      //     listCon.query = filterQuery;
      //     listCon.refresh();
      //   } else if (result == false) {
      //     filterQuery = listCon.query;
      //     for (var e in filterList) {
      //       if (e.value == true) {
      //         e.value.toggle();
      //       }
      //     }
      //   } else {
      //     for (var e in filterList) {
      //       if (e.value == true) {
      //         e.value.toggle();
      //       }
      //     }
      //   }
      // },
    );
    super.onInit();
  }

  void goToServiceSetup({String? id}) {
    Get.toNamed(
      Routes.SERVICE_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) {
      if (value == true) {
        listCon.refresh();
      }
    });
  }
}
