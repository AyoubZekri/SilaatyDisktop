import 'package:flutter/material.dart';
import '../../widget/cs_details/CSDetailsHeader.dart';
import '../../widget/cs_details/CSDetailsStats.dart';
import '../../widget/cs_details/CSInvoiceTable.dart';
import '../../../controller/Profaile/invoice/InvoiceController.dart';
import 'package:get/get.dart';

class CSDetailsScreen extends StatelessWidget {
  final String uuid;
  final String name;
  final String type; // 'customer' or 'supplier'

  const CSDetailsScreen({
    super.key,
    required this.uuid,
    required this.name,
    this.type = 'customer',
  });

  @override
  Widget build(BuildContext context) {
    // Inject and initialize the InvoicesController for this specific customer
    final controller = Get.put(InvoicesController());
    controller.uuid = uuid;
    controller.showInvoice();

    return Scaffold(
      backgroundColor: Colors.transparent, // Handled by background of the dashboard
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          children: [
            // Header Section (Breadcrumbs + ProfileCard)
            CSDetailsHeader(name: name, type: type),
            const SizedBox(height: 32),

            // Statistics Board
            const CSDetailsStats(),
            const SizedBox(height: 48),

            // Invoices Table
            const CSInvoiceTable(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
