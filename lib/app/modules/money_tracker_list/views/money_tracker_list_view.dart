import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_list_controller.dart';

class MoneyTrackerListView extends GetView<MoneyTrackerListController> {
  const MoneyTrackerListView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListComponent(
        controller: controller.listCon,
        itemBuilder:
            (item, index) => ReusableWidgets.generalShadowedContainer(
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: ListTile(
                onTap:
                    () => controller.goToTransactionSetup(id: item.documentid),
                horizontalTitleGap: 15,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                leading: ImageComponent(
                  localUrl:
                      item.type == 1
                          ? "assets/images/income.png"
                          : "assets/images/expense.png",
                  height: 40,
                  width: 40,
                ),

                title: TextComponent(value: item.note, maxLines: 2),

                subtitle: TextComponent(
                  value:
                      "${item.currency} ${InputFormatter.toCurrency(item.totalamount)}",
                  fontWeight: FontWeight.w600,
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MahasRadius.regular),
                    color: MahasColors.mutedGrey,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: TextComponent(
                    value: InputFormatter.displayDate(item.date.toDate()),
                    fontSize: MahasFontSize.small,
                    fontColor: MahasColors.white,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
