import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/class/Statusrequest.dart';
import '../../data/datasource/Remote/StatisticsData.dart';
import '../../data/model/FinanceReportModel.dart';

class Publicfinancecontroller extends GetxController {
  String? filter;
  DateTime? from;
  DateTime? to;
  FinanceReport? data;
  Statusrequest statusrequest = Statusrequest.none;
  Statisticsdata statisticsdata = Statisticsdata();
  var selectedAccount = "all_accounts".tr.obs;

  // Pagination state
  int currentPage = 1;
  int itemsPerPage = 10;

  int get totalPages => (data?.details?.length ?? 0) > 0
      ? ((data!.details!.length) / itemsPerPage).ceil()
      : 1;

  List<FinanceDetail> get paginatedDetails {
    if (data?.details == null) return [];
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > data!.details!.length) end = data!.details!.length;
    if (start >= data!.details!.length) return [];
    return data!.details!.sublist(start, end);
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      update();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
      update();
    }
  }

  void changeAccount(String value) {
    selectedAccount.value = value;
    getdata();
  }

  int? get sellerId {
    if (selectedAccount.value == "all_sellers") return null;
    return int.tryParse(selectedAccount.value);
  }

  getdata() async {
    update();
    var result = await statisticsdata.loadFinanceData(
      from: from,
      to: to,
      filter: filter,
      sellerId: sellerId,
    );
    print("===================================$result");
    if (result["status"] == 1) {
      data = FinanceReport.fromJson(result);
      currentPage = 1;
      print("===================================data$data");
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  String datefilter(String date) {
    print("=========================$date");

    if (filter == "today" || filter == "yesterday") {
      String normalized = date.length >= 19 ? date.substring(0, 19) : date;
      return formatSmartDate(normalized);
    } else {
      String normalized = date.length >= 10 ? date.substring(0, 10) : date;
      return formatSmartDate(normalized);
    }
  }

  String formatSmartDate(String input) {
    try {
      // تحقق من شكل الإدخال
      final hasHour = RegExp(
        r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2})?',
      ).hasMatch(input);
      final hasDay = RegExp(r'\d{4}-\d{2}-\d{2}$').hasMatch(input);
      final hasMonth = RegExp(r'\d{4}-\d{2}$').hasMatch(input);

      const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];

      if (hasHour) {
        String normalized = input.length > 19 ? input.substring(0, 19) : input;
        final date = DateTime.parse(normalized.replaceAll(' ', 'T'));
        final dayName = days[date.weekday - 1];
        final month = months[date.month - 1];
        final hour = DateFormat('HH:mm').format(date);
        return "$dayName, ${date.day} $month - $hour";
      }

      if (hasDay) {
        final date = DateTime.parse(input);
        final dayName = days[date.weekday - 1];
        final month = months[date.month - 1];
        return "$dayName, ${date.day} $month";
      }

      if (hasMonth) {
        final parts = input.split('-');
        final year = parts[0];
        final monthNum = int.parse(parts[1]);
        final month = months[monthNum - 1];
        return "$month $year";
      }

      return input;
    } catch (e) {
      return input;
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null) {
      filter = args["filter"];
      from = args["from"];
      to = args["to"];
      getdata();
    }
    super.onInit();
  }
}
