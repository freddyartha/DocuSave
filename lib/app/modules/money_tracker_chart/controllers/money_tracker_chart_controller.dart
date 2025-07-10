import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/chart_model.dart';
import 'package:docusave/app/mahas/models/item_value_model.dart';
import 'package:docusave/app/models/money_tracker_summary_model.dart';
import 'package:get/get.dart';

class MoneyTrackerChartController extends GetxController {
  RxBool loadingData = false.obs;
  RxBool chartIsEmpty = false.obs;
  late MoneyTrackerSummaryModel? summaryModel;
  final List<ItemValueModel> listSummary = [];
  final List<ChartModel> chartModelList = [];
  final List<ChartModel> chartMingguanList = [];
  final List<ItemValueModel> listSummaryMingguan = [];

  @override
  void onInit() {
    getThisMonthChart();
    super.onInit();
  }

  Future<void> getThisMonthChart() async {
    listSummary.clear();
    chartModelList.clear();
    chartMingguanList.clear();
    listSummaryMingguan.clear();
    loadingData(true);
    summaryModel = await FirebaseRepository.getMoneyTrackerSummaryByMonthKey(
      monthKey: ReusableStatics.getMonthKey(DateTime.now()),
      userUid: auth.currentUser!.uid,
    );
    if (summaryModel == null) {
      loadingData(false);
      chartIsEmpty(true);
    } else {
      _chartBulanIni();
      _chartMingguan();
      loadingData(false);
    }
  }

  void _chartBulanIni() {
    final income = summaryModel!.totalincome;
    final expense = summaryModel!.totalexpense;

    final expensePercentage =
        income == 0 ? 0 : ((expense / income) * 100).clamp(0, 999);
    final remainingPercentage =
        income == 0
            ? 0
            : (((income - expense) / income) * 100).clamp(-999, 999);

    chartModelList.addAll([
      ChartModel(
        label: "Out\n${expensePercentage.toStringAsFixed(1)}%",
        value: expense,
        color: MahasColors.darkgray,
      ),
      ChartModel(
        label: "In\n${remainingPercentage.toStringAsFixed(1)}%",
        value: income > expense ? income - expense : 0.0,
        color: MahasColors.primary,
      ),
    ]);

    listSummary.addAll([
      ItemValueModel(
        item: "pemasukan_bulan".tr,
        value: summaryModel!.totalincome,
      ),
      ItemValueModel(
        item: "pengeluaran_bulan".tr,
        value: summaryModel!.totalexpense,
      ),
    ]);
  }

  void _chartMingguan() {
    final currentWeek = InputFormatter.getWeekOfMonth(DateTime.now()) - 1;
    final budget = summaryModel!.weeklybudget![currentWeek];
    final weeklyExpense = summaryModel!.weeklyexpense[currentWeek];

    final weeklybudgetPercent =
        budget == 0 ? 0 : ((weeklyExpense / budget) * 100).clamp(0, 999);
    final weeklyExpPercent =
        budget == 0
            ? 0
            : (((budget - weeklyExpense) / budget) * 100).clamp(-999, 999);
    chartMingguanList.addAll([
      ChartModel(
        label: "Out\n${weeklyExpPercent.toStringAsFixed(1)}%",
        value: summaryModel!.weeklyexpense[currentWeek],
        color: MahasColors.darkgray,
      ),
      ChartModel(
        label: "Budget\n${weeklybudgetPercent.toStringAsFixed(1)}%",
        value: budget > weeklyExpense ? budget - weeklyExpense : 0.0,
        color: MahasColors.primary,
      ),
    ]);

    listSummaryMingguan.addAll([
      ItemValueModel(item: "pemasukan_minggu".tr, value: budget),
      ItemValueModel(item: "pengeluaran_minggu".tr, value: weeklyExpense),
    ]);
  }
}
