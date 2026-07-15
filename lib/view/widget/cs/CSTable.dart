import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Profaile/transaction/transactionController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../screen/C&S/DforC&S.dart';
import '../../../core/functions/dialogDelete.dart';
import 'AddCSDialog.dart';
import '../../../core/class/handlingview.dart';

class CSTable extends StatelessWidget {
  const CSTable({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final verticalScroll = ScrollController();
    final horizontalScroll = ScrollController();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark
          ? AppColor.textSecondary
          : const Color(0xFF8E92BC);

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(8),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: Column(
                      children: [
                        _buildTableHeader(isDark, subtitleColor),
                        const SizedBox(height: 8),
                        Divider(
                          color: isDark ? Colors.white10 : Colors.black12,
                          height: 1,
                        ),
                        GetBuilder<Transactioncontroller>(
                          builder: (csController) {
                            return Handlingview(
                              statusrequest: csController.statusrequest,
                              widget: Column(
                                children: csController.paginatedTransactions.map((
                                  data,
                                ) {
                                  final t = data.transaction;
                                  if (t == null)
                                    return const SizedBox.shrink();
                                  final name =
                                      '${t.name ?? ''} ${t.familyName ?? ''}'
                                          .trim();
                                  final id = 'C-${t.id}#';
                                  final phone = t.phoneNumber ?? '';
                                  final sumPrice =
                                      double.tryParse(
                                        data.sumPrice?.toString() ?? '0',
                                      ) ??
                                      0;
                                  final isDebt = sumPrice < 0;
                                  final isNeutral = sumPrice == 0;
                                  final balance = sumPrice.abs()
                                        .toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');

                                  return _buildTableRow(
                                    uuid: t.uuid ?? '',
                                    name: name,
                                    id: id,
                                    phone: phone,
                                    balance:
                                        '${isDebt ? '- ' : (isNeutral ? '' : '+ ')}$balance',
                                    currency: 'currency_dz'.tr,
                                    isDebt: isDebt,
                                    isNeutral: isNeutral,
                                    isDark: isDark,
                                    titleColor: titleColor,
                                    subtitleColor: subtitleColor,
                                    type: t.transactions ?? 0,
                                    firstName: t.name ?? '',
                                    lastName: t.familyName ?? '',
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GetBuilder<Transactioncontroller>(
              builder: (csController) =>
                  _buildPagination(isDark, subtitleColor, csController),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTableHeader(bool isDark, Color headerColor) {
    final style = TextStyle(
      fontSize: 14,
      color: headerColor,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 250,
            child: Text(
              'customer_supplier_name'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text('type'.tr, textAlign: TextAlign.right, style: style),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'phone_number'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'balance_debt'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            child: Center(child: Text('actions'.tr, style: style)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String uuid,
    required String name,
    required String id,
    required String phone,
    required String balance,
    required String currency,
    required bool isDebt,
    bool isNeutral = false,
    required bool isDark,
    required Color titleColor,
    required Color subtitleColor,
    required int type,
    required String firstName,
    required String lastName,
  }) {
    final balanceColor = isNeutral
        ? Colors.grey
        : (isDebt ? const Color(0xFFF44336) : const Color(0xFF28C76F));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 250,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.primaryPurple.withOpacity(0.1),
                  child: Text(
                    name.substring(0, 1),
                    style: const TextStyle(
                      color: AppColor.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Start = Right in RTL
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'id'.tr} $id',
                      style: TextStyle(color: subtitleColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: type == 2
                      ? AppColor.primaryPurple.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type == 2 ? 'customers'.tr : 'suppliers'.tr,
                  style: TextStyle(
                    color: type == 2 ? AppColor.primaryPurple : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              phone,
              textAlign: TextAlign.right,
              style: TextStyle(color: titleColor, fontSize: 16),
            ),
          ),
          SizedBox(
            width: 180,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  balance,
                  style: TextStyle(
                    color: balanceColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currency,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(
                  Icons.edit_outlined,
                  Colors.grey,
                  isDark,
                  onTap: () async {
                    await Get.dialog(
                      AddCSDialog(
                        isEdit: true,
                        data: {
                          'uuid': uuid,
                          'name': firstName,
                          'lastName': lastName,
                          'phone': phone,
                          'type': type,
                        },
                      ),
                    );
                    Get.find<Transactioncontroller>().getTransactions();
                  },
                ),
                _buildActionIcon(
                  Icons.delete_outline_rounded,
                  Colors.redAccent,
                  isDark,
                  onTap: () {
                    dialogDelete(
                      onConfirm: () => Get.find<Transactioncontroller>()
                          .deletetransaction(uuid),
                    );
                  },
                ),
                _buildActionIcon(
                  Icons.visibility_outlined,
                  AppColor.primaryPurple,
                  isDark,
                  onTap: () {
                    Get.dialog(
                      barrierColor: Colors.black.withValues(alpha: 0.5),
                      Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: 1000,
                          height: 800,
                          decoration: BoxDecoration(
                            color: isDark ? AppColor.surfaceDark : const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CSDetailsScreen(
                              name: name,
                              uuid: uuid,
                              type: type == 2 ? 'customer' : 'supplier',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
    IconData icon,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildPagination(
    bool isDark,
    Color textColor,
    Transactioncontroller controller,
  ) {
    final start = controller.transaction.isEmpty ? 0 : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
    final end = (start + controller.paginatedTransactions.length - 1).clamp(0, controller.transaction.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'عرض $start إلى $end من أصل ${controller.transaction.length} جهة',
          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildPageItem('<', false, isDark, textColor, () => controller.previousPage()),
            ...List.generate(
              controller.totalPages,
              (index) {
                final page = index + 1;
                return _buildPageItem(
                  page.toString(),
                  page == controller.currentPage,
                  isDark,
                  textColor,
                  () => controller.goToPage(page),
                );
              },
            ),
            _buildPageItem('>', false, isDark, textColor, () => controller.nextPage()),
          ],
        ),
      ],
    );
  }

  Widget _buildPageItem(
    String label,
    bool active,
    bool isDark,
    Color textColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColor.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active
              ? null
              : Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
