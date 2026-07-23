import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../controller/items/AdditemsController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/sale/ProductCatalog.dart';
import '../../widget/sale/SaleCart.dart';
import '../../../controller/Dashpord/Salecontroller.dart';
import '../../widget/stock/AddProductDialog.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String _barcodeBuffer = '';
  DateTime? _lastKeyPress;
  late final SaleController _saleController;

  @override
  void initState() {
    super.initState();
    _saleController = Get.put(SaleController());
    _saleController.type = 1; // 1 means Purchase
    _saleController.saleType.value = 1; 
    _saleController.isCashCustomer.value = false; // Force supplier selection
    _saleController.selectedCustomer.value = 'اختر مورد'.tr;
    _saleController.fetchCustomers();
    
    RawKeyboard.instance.addListener(_handleRawKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleRawKeyEvent);
    super.dispose();
  }

  void _handleRawKeyEvent(RawKeyEvent event) {
    if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
      return;
    }

    if (event is RawKeyDownEvent) {
      final now = DateTime.now();

      if (_lastKeyPress != null && now.difference(_lastKeyPress!).inMilliseconds > 2000) {
        _barcodeBuffer = '';
      }
      _lastKeyPress = now;

      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_barcodeBuffer.length >= 3) {
          try {
            Get.find<Itemscontroller>().searchController.text = _barcodeBuffer;
          } catch (_) {}
          _saleController.search(_barcodeBuffer);
          _barcodeBuffer = '';
        }
        _barcodeBuffer = '';
      } else {
        String? char = event.character;
        
        const azertyMap = {'&': '1', 'é': '2', '"': '3', "'": '4', '(': '5', '-': '6', 'è': '7', '_': '8', 'ç': '9', 'à': '0'};
        if (char != null && azertyMap.containsKey(char)) {
          char = azertyMap[char]!;
        } else if (char == null || char.isEmpty || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(char)) {
           String label = event.logicalKey.keyLabel;
           if (label.length == 1) {
             char = label;
           } else if (label.startsWith('Numpad ')) {
             char = label.replaceAll('Numpad ', '');
           }
        }

        if (char != null && char.isNotEmpty && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(char)) {
          _barcodeBuffer += char;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final backgroundColor = isDark ? AppColor.backgroundDark : const Color(0xFFF4F7FE);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 13, 
                child: Column(
                  children: [
                    // New Product Button Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "فاتورة مورد",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColor.textDark : AppColor.textLight,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              var result = await Get.dialog(
                                const AddProductDialog(isEdit: false, isDraft: true),
                                barrierDismissible: false,
                              );
                              
                              if (result != null && result is Map<String, dynamic>) {
                                if (result.containsKey('draft_data')) {
                                  var draftData = result['draft_data'] as Map<String, dynamic>;
                                  double qty = double.tryParse(draftData['product_quantity']?.toString() ?? '1.0') ?? 1.0;
                                  _saleController.addProductWithQuantity(draftData, qty, draftPayload: result);
                                } else {
                                  double qty = double.tryParse(result['product_quantity']?.toString() ?? '1.0') ?? 1.0;
                                  _saleController.addProductWithQuantity(result, qty);
                                }
                              }
                            },
                            icon: const Icon(Icons.add_box_rounded, color: Colors.white),
                            label: const Text(
                              "إضافة منتج جديد",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColor.primaryPurple.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: ProductCatalog()),
                  ],
                )
              ),
              const Expanded(flex: 7, child: SaleCart()),
            ],
          ),
        ),
      );
    });
  }
}
