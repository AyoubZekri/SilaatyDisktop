import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/AdditemsController.dart';
import '../../../controller/items/Edititemcontroller.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../data/model/Product_Model.dart' as Prodact;
import '../../../LinkApi.dart';
import 'dart:io';
import 'dart:math';
import '../../../core/functions/valiedinput.dart';
import '../../../core/constant/imageassets.DART';
import '../CustemTextField.dart';

class AddProductDialog extends StatelessWidget {
  final bool isEdit;
  final Prodact.Data? product;

  const AddProductDialog({super.key, this.isEdit = false, this.product});

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      return GetBuilder<Edititemcontroller>(
        builder: (controller) => _ProductForm(
          isEdit: true,
          nameController: controller.nameController,
          qtyController: controller.quantityController,
          purchasePriceController: controller.pricePurchaseController,
          salePriceController: controller.priseController,
          wholesalePriceController: controller.priseWholesaleController,
          halfWholesalePriceController: controller.priseHalfWholesaleController,
          barcodeController: controller.barcodeController,
          categories: controller.categories
              .map((c) => {'uuid': c.uuid ?? '', 'name': c.categorisName ?? ''})
              .toList(),
          selectedCategoryUuid: controller.selectedtypeuuId,
          onCategoryChanged: (val) {
            controller.selectedtypeuuId = val;
            final cat = controller.categories.firstWhereOrNull(
              (c) => c.uuid == val,
            );
            if (cat != null) {
              controller.selectedCategoryId = cat.id;
            }
            controller.update();
          },
          onSave: () => controller.EditProduct(),
          imageUrl: controller.imageUrl ?? '',
          onImageUpload: () => controller.imageupload(),
          productType: controller.type ?? 1,
          onProductTypeChanged: (val) {
            controller.type = val;
            controller.update();
          },
          file: controller.file,
          formKey: controller.formstate,
        ),
      );
    } else {
      return GetBuilder<Additemscontroller>(
        builder: (controller) => _ProductForm(
          isEdit: false,
          nameController: controller.nameController,
          qtyController: controller.quantityController,
          purchasePriceController: controller.pricePurchaseController,
          salePriceController: controller.priseController,
          wholesalePriceController: controller.priseWholesaleController,
          halfWholesalePriceController: controller.priseHalfWholesaleController,
          barcodeController: controller.barcodeController,
          categories: controller.categories
              .map((c) => {'uuid': c.uuid ?? '', 'name': c.categorisName ?? ''})
              .toList(),
          selectedCategoryUuid: controller.selectedtypeuuid,
          onCategoryChanged: (val) {
            controller.selectedtypeuuid = val;
            final cat = controller.categories.firstWhereOrNull(
              (c) => c.uuid == val,
            );
            if (cat != null) {
              controller.selectedCategoryId = cat.id;
            }
            controller.update();
          },
          onSave: () => controller.addProduct(),
          imageUrl: '',
          onImageUpload: () => controller.imageupload(),
          productType: controller.type,
          onProductTypeChanged: (val) {
            controller.typeProduct(val);
          },
          file: controller.file,
          formKey: controller.formstate,
        ),
      );
    }
  }
}

class _ProductForm extends StatefulWidget {
  final bool isEdit;
  final TextEditingController nameController;
  final TextEditingController qtyController;
  final TextEditingController purchasePriceController;
  final TextEditingController salePriceController;
  final TextEditingController wholesalePriceController;
  final TextEditingController halfWholesalePriceController;
  final TextEditingController barcodeController;
  final List<Map<String, String>> categories;
  final String? selectedCategoryUuid;
  final Function(String) onCategoryChanged;
  final VoidCallback onSave;
  final String imageUrl;
  final VoidCallback onImageUpload;
  final int productType;
  final Function(int) onProductTypeChanged;
  final File? file;
  final GlobalKey<FormState>? formKey;

  const _ProductForm({
    required this.isEdit,
    required this.nameController,
    required this.qtyController,
    required this.purchasePriceController,
    required this.salePriceController,
    required this.wholesalePriceController,
    required this.halfWholesalePriceController,
    required this.barcodeController,
    required this.categories,
    required this.selectedCategoryUuid,
    required this.onCategoryChanged,
    required this.onSave,
    required this.imageUrl,
    required this.onImageUpload,
    required this.productType,
    required this.onProductTypeChanged,
    this.file,
    this.formKey,
  });

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  // 0: Auto, 1: Manual, 2: Scan
  int barcodeMode = 0;
  String _barcodeBuffer = '';
  DateTime? _lastKeyPress;

  double get profitMargin {
    double p =
        double.tryParse(
          widget.purchasePriceController.text.replaceAll(',', ''),
        ) ??
        0;
    double s =
        double.tryParse(widget.salePriceController.text.replaceAll(',', '')) ??
        0;
    if (p == 0) return 0;
    return ((s - p) / p) * 100;
  }

  void _generateBarcode() {
    setState(() {
      widget.barcodeController.text = List.generate(
        11,
        (_) => Random().nextInt(10),
      ).join();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.purchasePriceController.addListener(_onPriceChanged);
    widget.salePriceController.addListener(_onPriceChanged);
    RawKeyboard.instance.addListener(_handleRawKeyEvent);
  }

  @override
  void dispose() {
    widget.purchasePriceController.removeListener(_onPriceChanged);
    widget.salePriceController.removeListener(_onPriceChanged);
    RawKeyboard.instance.removeListener(_handleRawKeyEvent);
    super.dispose();
  }

  void _handleRawKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final now = DateTime.now();

      if (_lastKeyPress != null &&
          now.difference(_lastKeyPress!).inMilliseconds > 2000) {
        _barcodeBuffer = '';
      }
      _lastKeyPress = now;

      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_barcodeBuffer.length >= 3) {
          setState(() {
            barcodeMode = 2; // Auto-switch to Scan mode
            if (!widget.barcodeController.text.contains(_barcodeBuffer)) {
              widget.barcodeController.text = _barcodeBuffer;
            }
          });
          _barcodeBuffer = '';
        }
        _barcodeBuffer = '';
      } else {
        String? char = event.character;

        const azertyMap = {
          '&': '1',
          'é': '2',
          '"': '3',
          "'": '4',
          '(': '5',
          '-': '6',
          'è': '7',
          '_': '8',
          'ç': '9',
          'à': '0',
        };
        if (char != null && azertyMap.containsKey(char)) {
          char = azertyMap[char]!;
        } else if (char == null ||
            char.isEmpty ||
            !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(char)) {
          String label = event.logicalKey.keyLabel;
          if (label.length == 1) {
            char = label;
          } else if (label.startsWith('Numpad ')) {
            char = label.replaceAll('Numpad ', '');
          }
        }

        if (char != null &&
            char.isNotEmpty &&
            RegExp(r'^[a-zA-Z0-9]+$').hasMatch(char)) {
          _barcodeBuffer += char;
        }
      }
    }
  }

  Future<void> _printBarcode() async {
    final barcodeData = widget.barcodeController.text;
    if (barcodeData.isEmpty) {
      Get.snackbar(
        'خطأ',
        'لا يوجد باركود لطباعته',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          50 * PdfPageFormat.mm,
          30 * PdfPageFormat.mm,
          marginAll: 2 * PdfPageFormat.mm,
        ),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 2),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: barcodeData,
                  width: double.infinity,
                  height: 50,
                  drawText: true,
                  textStyle: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'طباعة باركود - $barcodeData',
    );
  }

  void _onPriceChanged() {
    setState(() {});
  }

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2);
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains(r':\') || path.contains(':/') || path.startsWith('/'))
      return FileImage(File(path));
    return NetworkImage("${Applink.image}/$path");
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final primaryColor = AppColor.primaryPurple;

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final fieldColor = isDark
          ? Colors.white.withOpacity(0.05)
          : const Color(0xFFF0F4FF);
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: surfaceColor,
        child: Form(
          key: widget.formKey,
          child: Container(
            width: 900,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.isEdit
                                ? 'edit_product'.tr
                                : 'add_new_product'.tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.isEdit
                                  ? Icons.edit_note_rounded
                                  : Icons.add_box_rounded,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Image Upload Area
                  Text(
                    'product_image'.tr,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: widget.onImageUpload,
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                          width: 1.5,
                        ),
                      ),
                      child: widget.file != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                widget.file!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            )
                          : widget.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                image: _getImageProvider(widget.imageUrl),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            )
                          : CustomPaint(
                              painter: DashedBorderPainter(
                                color: isDark ? Colors.white24 : Colors.black12,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo_rounded,
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'upload_image_hint'.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Product Names
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'product_name_ar'.tr,
                          'مثال: حليب كامل الدسم',
                          fieldColor,
                          textColor,
                          controller: widget.nameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Category, Type and Qty
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCategoryDropdown(
                          'select_category'.tr,
                          fieldColor,
                          textColor,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'نوع الكمية',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: _buildToggleButton(
                                    'بالقطعة',
                                    widget.productType == 1,
                                    () => widget.onProductTypeChanged(1),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildToggleButton(
                                    'بالميزان',
                                    widget.productType == 2,
                                    () => widget.onProductTypeChanged(2),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildQtyField(
                          'initial_qty'.tr,
                          '0',
                          fieldColor,
                          textColor,
                          controller: widget.qtyController,
                          isDecimal: widget.productType == 2,
                          suffixIcon: Icons.unarchive_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Pricing Section
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      // Purchase Price
                      Expanded(
                        child: _buildPriceField(
                          'purchase_price_label'.tr,
                          widget.purchasePriceController,
                          isDark,
                          textColor,
                          primaryColor,
                          false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Sale Price
                      Expanded(
                        child: _buildPriceField(
                          'sale_price_label'.tr,
                          widget.salePriceController,
                          isDark,
                          textColor,
                          primaryColor,
                          true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Wholesale and Half Wholesale
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: _buildPriceField(
                          'سعر الجملة',
                          widget.wholesalePriceController,
                          isDark,
                          textColor,
                          primaryColor,
                          false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPriceField(
                          'سعر نصف جملة',
                          widget.halfWholesalePriceController,
                          isDark,
                          textColor,
                          primaryColor,
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Barcode Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'barcode_label'.tr,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildToggleButton(
                            'auto_generate'.tr,
                            barcodeMode == 0,
                            () => setState(() {
                              barcodeMode = 0;
                              _generateBarcode();
                            }),
                          ),
                          const SizedBox(width: 12),
                          _buildToggleButton(
                            'manual_entry'.tr,
                            barcodeMode == 1,
                            () => setState(() {
                              barcodeMode = 1;
                              widget.barcodeController.clear();
                            }),
                          ),
                          const SizedBox(width: 12),
                          _buildToggleButton(
                            'بالمسح',
                            barcodeMode == 2,
                            () => setState(() {
                              barcodeMode = 2;
                              widget.barcodeController.clear();
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: CustemTextField(
                              controller: widget.barcodeController,
                              readOnly:
                                  barcodeMode !=
                                  1, // Only manual allows keyboard typing
                              textAlign: TextAlign.right,
                              hint: 'barcode_label'.tr,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  validInput(val ?? "", 13, 8, "number"),
                              icon: Icons
                                  .qr_code_scanner_rounded, // Use prefix icon provided by CustemTextField
                            ),
                          ),
                          if (barcodeMode == 0) ...[
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: _generateBarcode,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 54,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'generate'.tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (barcodeMode == 2) ...[
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: _printBarcode,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 54,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'طباعة الباركود',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.print_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Footer Actions
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: widget.onSave,
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            label: Text(
                              widget.isEdit
                                  ? 'edit_product'.tr
                                  : 'save_product'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fieldColor,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'cancel'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPriceField(
    String label,
    TextEditingController controller,
    bool isDark,
    Color textColor,
    Color primaryColor,
    bool highlight,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? primaryColor.withOpacity(0.05) : Colors.transparent,
        border: Border.all(
          color: highlight
              ? primaryColor.withOpacity(0.2)
              : (isDark ? Colors.white10 : Colors.grey.withOpacity(0.2)),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight ? primaryColor : textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: CustemTextField(
                  controller: controller,
                  hint: '0.00',
                  textAlign: TextAlign.right,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) => validInput(val ?? "", 100, 1, "decimal"),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'currency_dz'.tr,
                style: TextStyle(color: highlight ? primaryColor : Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    Color color,
    Color textColor, {
    required TextEditingController controller,
    bool isRtl = true,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        CustemTextField(
          controller: controller,
          hint: hint,
          textAlign: TextAlign.center,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          validator: (val) => validInput(val ?? "", 100, 1, "text"),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.grey, size: 20)
              : null,
        ),
      ],
    );
  }

  Widget _buildQtyField(
    String label,
    String hint,
    Color color,
    Color textColor, {
    required TextEditingController controller,
    required bool isDecimal,
    bool isRtl = true,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        CustemTextField(
          controller: controller,
          hint: hint,
          keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
          textAlign: TextAlign.center,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          validator: (val) =>
              validInput(val ?? "", 100, 1, isDecimal ? "decimal" : "number"),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.grey, size: 20)
              : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(
    String label,
    Color color,
    Color textColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:
                  widget.selectedCategoryUuid != null &&
                      widget.categories.any(
                        (c) => c['uuid'] == widget.selectedCategoryUuid,
                      )
                  ? widget.selectedCategoryUuid
                  : (widget.categories.isNotEmpty
                        ? widget.categories.first['uuid']
                        : null),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              dropdownColor: isDark ? AppColor.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: widget.categories.map((cat) {
                return DropdownMenuItem(
                  value: cat['uuid'],
                  child: Text(
                    cat['name']!.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) widget.onCategoryChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColor.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: AppColor.primaryPurple.withOpacity(0.2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColor.primaryPurple : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    final path = Path()
      ..addRRect(
        RRect.fromLTRBR(
          0,
          0,
          size.width,
          size.height,
          const Radius.circular(16),
        ),
      );
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
