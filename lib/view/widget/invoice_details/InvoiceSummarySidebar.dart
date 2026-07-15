import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Profaile/invoice/Shwoinvoicecontroller.dart';

class InvoiceSummarySidebar extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Shwoinvoicecontroller controller;

  const InvoiceSummarySidebar({
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFinancialSummary(),
      ],
    );
  }

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Widget _buildFinancialSummary() {
    final sumPrice = double.tryParse(controller.productSale?.sumPrice.toString() ?? "0") ?? 0;
    final discount = double.tryParse(controller.productSale?.discount.toString() ?? "0") ?? 0;
    final paidAmount = double.tryParse(controller.productSale?.paymentprice.toString() ?? "0") ?? 0;
    
    final totalAmountDue = sumPrice - discount;
    final remainingAmount = controller.getRemainingAmount();
    
    final double progressValue = totalAmountDue > 0 ? (paidAmount / totalAmountDue).clamp(0.0, 1.0) : 1.0;

    return Container(
      height: 500,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColor.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'financial_summary'.tr,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSummaryItem('subtotal_amount'.tr, _formatNumber(sumPrice)),
          const SizedBox(height: 16),
          _buildDiscountItem(discount),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'total_amount_due'.tr,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatNumber(totalAmountDue),
                    style: TextStyle(
                      color: AppColor.primaryPurple,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'currency_dz'.tr,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildPaymentProgress(paidAmount, remainingAmount, progressValue),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          '$val ${'currency_dz'.tr}',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDiscountItem(double discount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'total_discount'.tr,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            '- ${_formatNumber(discount)} ${'currency_dz'.tr}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProgress(double paidAmount, double remainingAmount, double progressValue) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'paid_amount'.tr,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Text(
              '${_formatNumber(paidAmount)} ${'currency_dz'.tr}',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
                remainingAmount <= 0 ? Colors.green : Colors.orange),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'remaining_amount'.tr,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Text(
              '${_formatNumber(remainingAmount)} ${'currency_dz'.tr}',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
