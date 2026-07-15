import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/sale/SaleNavigation.dart';
import '../../widget/sale/ProductCatalog.dart';
import '../../widget/sale/SaleCart.dart';
import '../../../controller/Dashpord/Salecontroller.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  String _barcodeBuffer = '';
  DateTime? _lastKeyPress;
  late final SaleController _saleController;

  @override
  void initState() {
    super.initState();
    _saleController = Get.put(SaleController());
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

      // Clear buffer if it's been more than 2 seconds
      if (_lastKeyPress != null &&
          now.difference(_lastKeyPress!).inMilliseconds > 2000) {
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
      final backgroundColor = isDark
          ? AppColor.backgroundDark
          : const Color(0xFFF4F7FE);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 13, child: ProductCatalog()),
              const Expanded(flex: 7, child: SaleCart()),
            ],
          ),
        ),
      );
    });
  }
}
