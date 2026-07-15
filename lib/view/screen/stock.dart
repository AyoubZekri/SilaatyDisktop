import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/HomeScreen/SiedBarController.dart';
import '../../controller/items/ItemsController.dart';
import '../../core/constant/Colorapp.dart';
import '../widget/stock/StockHeader.dart';
import '../widget/stock/StockStatsBoard.dart';
import '../widget/stock/StockTable.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String _barcodeBuffer = '';
  DateTime? _lastKeyPress;
  late final Itemscontroller _stockController;

  @override
  void initState() {
    super.initState();
    _stockController = Get.put(Itemscontroller());
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
      if (_lastKeyPress != null && now.difference(_lastKeyPress!).inMilliseconds > 2000) {
        _barcodeBuffer = '';
      }
      _lastKeyPress = now;

      if (event.logicalKey == LogicalKeyboardKey.enter || 
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_barcodeBuffer.length >= 3) {
          _stockController.searchController.text = _barcodeBuffer;
          _stockController.search(_barcodeBuffer);
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
    final controller = Get.find<Siedbarcontroller>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      return Scaffold(
        backgroundColor:
            isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
        body: const SingleChildScrollView(
          child: Column(
            children: [
              StockHeader(),
              StockStatsBoard(),
              StockTable(),
            ],
          ),
        ),
      );
    });
  }
}
