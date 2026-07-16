import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:silaaty_desktop/controller/items/Edititemcontroller.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/Colorapp.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:silaaty_desktop/data/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:uuid/uuid.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class Informationitemcontroller extends GetxController {
  late String uuid;
  final quantityController = TextEditingController();
  Myservices myservices = Get.find();
  final GlobalKey ticketKey = GlobalKey();

  late int? id = myservices.sharedPreferences?.getInt("id");

  ProdactData prodactData = ProdactData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  bool isPrinting = false;
  int get printerWidth => 384; // Fixed 384 for labels (58mm)
  List<Data> InfoProduct = [];
  Future<void> GotoEdititem() async {
    final product = InfoProduct[0];
    final controller = Get.put(Edititemcontroller());
    controller.initData(product);
    await Get.toNamed(
      Approutes.edititemcontroller,
    );
  }

  getProdact() async {
    Map<String, Object?> data = {'uuid': uuid};
    var result = await prodactData.ShwoProdact(data);

    print("============================================== $result");
    print("User ID: $uuid");

    if (result.isNotEmpty) {
      InfoProduct =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  deleteProdact(String uid) async {
    update();
    Map<String, Object?> data = {'uuid': uid};
    var result = await prodactData.deleteProdact(data);

    print("============================================== $result");
    print("$uid");
    if (result == true) {
      Get.find<RefreshService>().fire();
      Get.back(result: true);
    } else {
      showSnackbar("error".tr, "error_deleting_product".tr, Colors.red);

      statusrequest = Statusrequest.failure;
    }
    update();
  }

  Future<void> editquantityProduct() async {
    if (double.parse(quantityController.text) <= 0) {
      showSnackbar("error".tr, "الكمية يجب أن تكون أكبر من 0".tr, Colors.red);
      return;
    }
    final double quantity =
        double.parse(InfoProduct.first.productQuantity ?? "0") +
            double.parse(quantityController.text);
    final data = {
      "uuid": uuid,
      'product_quantity': quantity,
      'updated_at': DateTime.now().toIso8601String(),
    };

    Map<String, Object?> dataSale = {
      "uuid": Uuid().v4(),
      "product_uuid": uuid,
      "product_name": InfoProduct.first.productName ?? "",
      "quantity": double.parse(quantityController.text),
      "unit_price": InfoProduct.first.productPricePurchase ?? "0",
      "subtotal": double.parse(quantityController.text) *
          double.parse(InfoProduct.first.productPricePurchase.toString()),
      "type_sales": 3, // 1 = in 2 = out 3
      "user_id": id,
      "created_at": DateTime.now().toIso8601String(),
    };

    final result = await prodactData.updateQuantityProduct(data, dataSale);
    print("========================================$result");
    if (result) {
      Get.find<RefreshService>().fire();
      Get.back();
      quantityController.clear();
      getProdact();
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void showWidthSelectionDialog({
    required String name,
    required String barcode,
    required double price,
  }) {
    Get.defaultDialog(
      title: "مقاس الورق".tr,
      middleText: "يرجى اختيار مقاس ورق الطباعة (سيتم حفظه دائماً)".tr,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          myservices.sharedPreferences?.setInt("printer_width", 384);
          Get.back();
          printUniversalTicket(name: name, barcode: barcode, price: price);
        },
        child: Text("58mm".tr, style: const TextStyle(color: Colors.white)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          myservices.sharedPreferences?.setInt("printer_width", 576);
          Get.back();
          printUniversalTicket(name: name, barcode: barcode, price: price);
        },
        child: Text("80mm".tr, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> printUniversalTicket({
    required String name,
    required String barcode,
    required double price,
  }) async {
    if (isPrinting) return;
    isPrinting = true;
    update();

    try {
      final doc = pw.Document();

      var dataFontBold = await rootBundle.load("assets/fonts/static/Cairo-Bold.ttf");
      var cairoFontBold = pw.Font.ttf(dataFontBold);

      final format = PdfPageFormat(40 * PdfPageFormat.mm, 20 * PdfPageFormat.mm, marginAll: 1 * PdfPageFormat.mm);

      doc.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    name,
                    style: pw.TextStyle(font: cairoFontBold, fontSize: 7),
                    maxLines: 1,
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.BarcodeWidget(
                    data: barcode,
                    barcode: pw.Barcode.code128(),
                    width: 35 * PdfPageFormat.mm,
                    height: 10 * PdfPageFormat.mm,
                    drawText: true,
                    textStyle: pw.TextStyle(font: cairoFontBold, fontSize: 6),
                  ),
                  pw.Text(
                    "$price DA",
                    style: pw.TextStyle(font: cairoFontBold, fontSize: 7),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final printers = await Printing.listPrinters();
      Printer? selectedPrinter;

      for (var printer in printers) {
        final printerName = printer.name.toLowerCase();
        if (printerName.contains('pos') ||
            printerName.contains('receipt') ||
            printerName.contains('thermal') ||
            printerName.contains('80') ||
            printerName.contains('58') ||
            printerName.contains('xp') ||
            printerName.contains('label') ||
            printerName.contains('barcode') ||
            printerName.contains('esc')) {
          selectedPrinter = printer;
          break;
        }
      }

      if (selectedPrinter == null) {
        showSnackbar(
          "تنبيه".tr,
          "لم يتم العثور على طابعة ملصقات متصلة بالجهاز.".tr,
          Colors.orange,
        );
      } else {
        await Printing.directPrintPdf(
          printer: selectedPrinter,
          onLayout: (PdfPageFormat _) async => doc.save(),
        );
      }
    } catch (e) {
      showSnackbar("error".tr, "حدث خطأ أثناء الطباعة".tr, Colors.red);
    } finally {
      isPrinting = false;
      update();
    }
  }

  void onQuantityChanged(double value) {
    update();
  }

  @override
  void onInit() {
    super.onInit();
    uuid = Get.arguments['uuid'];
    getProdact();
  }

  List<int> convertImageToTSPL(img.Image image) {
    // 1. جعل العرض يقبل القسمة على 8 (Padding)
    int width = (image.width / 8).ceil() * 8;
    int widthBytes = width ~/ 8;

    List<int> bytes = [];

    // قراءة نوع الورق من الإعدادات
    Myservices myServices = Get.find();
    String paperType =
        myServices.sharedPreferences?.getString("barcode_paper_type") ??
            "receipt";

    int contentHeight = image.height;
    int topMargin = 0;

    // نبحث عن أول وآخر سطر فيه محتوى (غير أبيض)
    // لقص الفراغ الزائد - يعمل على كلا نوعي الورق
    int lastContentRow = 0;
    int firstContentRow = image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;
        if (val < 128) {
          if (y < firstContentRow) firstContentRow = y;
          if (y > lastContentRow) lastContentRow = y;
          break;
        }
      }
    }

    if (lastContentRow > 0) {
      // قص الصورة بحيث نأخذ المحتوى الفعلي فقط
      topMargin = (firstContentRow).clamp(0, image.height);
      contentHeight =
          (lastContentRow - topMargin).clamp(1, image.height - topMargin);
    }

    int marginDots = 0;
    if (paperType == "receipt") {
      marginDots = 80;
    }

    if (paperType == "label") {
      bytes.addAll(ascii.encode("SIZE 47.5 mm, 20 mm\r\n"));
      bytes.addAll(ascii.encode("GAP 3 mm,0\r\n"));
    } else {
      // ورق فواتير: المقاس الفعلي للمحتوى + الهامش من الأعلى والأسفل
      double totalHeightMm = (contentHeight + (marginDots * 2)) / 8;
      bytes.addAll(ascii
          .encode("SIZE 57 mm, ${totalHeightMm.toStringAsFixed(1)} mm\r\n"));
      bytes.addAll(ascii.encode("GAP 0,0\r\n"));
    }

    bytes.addAll(ascii.encode("REFERENCE 0,0\r\n"));
    // تسريع الطباعة للحد الأقصى مع الحفاظ على وضوح الحبر
    bytes.addAll(ascii.encode("SPEED 4\r\n"));
    bytes.addAll(ascii.encode("DENSITY 8\r\n"));
    bytes.addAll(ascii.encode("DIRECTION 1\r\n"));
    bytes.addAll(ascii.encode("CLS\r\n"));

    // حساب الإزاحة لتوسيط الباركود أفقياً
    // حساب عرض الورق الحقيقي بالنقاط حسب النوع
    int paperWidthDots;

    if (paperType == "label") {
      // 40mm
      paperWidthDots = 40 * 8;
    } else {
      // 58mm
      paperWidthDots = 58 * 8;
    }
    int imageWidthDots = widthBytes * 8;
    int offsetX = ((paperWidthDots - imageWidthDots) / 2)
        .clamp(0, paperWidthDots)
        .toInt();

    int offsetY = 0;
    if (paperType == "label") {
      // الارتفاع الفعلي للتيكي هو 20 ملم = 160 نقطة (20 * 8)
      int labelHeightDots = 20 * 8;
      // توسيط المحتوى عمودياً تماماً داخل مساحة التيكي
      offsetY = ((labelHeightDots - contentHeight) / 2)
          .clamp(0, labelHeightDots)
          .toInt();
    } else if (paperType == "receipt") {
      // في حالة الورق المتصل، نبدأ الطباعة بعد الهامش العلوي
      offsetY = marginDots;
    }

    // أرسل BITMAP للمحتوى فقط
    bytes.addAll(
        ascii.encode("BITMAP $offsetX,$offsetY,$widthBytes,$contentHeight,0,"));

    for (int y = topMargin; y < topMargin + contentHeight; y++) {
      for (int x = 0; x < widthBytes; x++) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          int px = x * 8 + bit;
          if (px < image.width && y < image.height) {
            var pixel = image.getPixel(px, y);
            double val = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b);
            if (val > 128) {
              byte |= (0x80 >> bit);
            }
          } else {
            byte |= (0x80 >> bit);
          }
        }
        bytes.add(byte);
      }
    }

    bytes.addAll(ascii.encode("\r\nPRINT 1,1\r\n"));
    return bytes;
  }

  List<int> _convertImageToEscPos(img.Image image) {
    Myservices myServices = Get.find();

    String paperType =
        myServices.sharedPreferences?.getString("barcode_paper_type") ??
            "receipt";

    // =========================
    // إعدادات الورق
    // =========================

    int paperWidthDots;
    int topBottomMargin;

    if (paperType == "label") {
      paperWidthDots = 320; // 40mm
      topBottomMargin = 0;
    } else {
      paperWidthDots = 464; // 58mm
      topBottomMargin = 80;
    }

    // =========================
    // قص الفراغ الأبيض
    // =========================

    int lastContentRow = 0;
    int firstContentRow = image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);

        double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;

        if (val < 128) {
          if (y < firstContentRow) firstContentRow = y;
          if (y > lastContentRow) lastContentRow = y;
          break;
        }
      }
    }

    int topMargin = 0;
    int contentHeight = image.height;

    if (lastContentRow > 0) {
      topMargin = firstContentRow.clamp(0, image.height);

      contentHeight =
          (lastContentRow - topMargin + 1).clamp(1, image.height - topMargin);
    }

    // =========================
    // توسيط أفقي (داخل الكانفاس برمجياً)
    // =========================

    int offsetX =
        ((paperWidthDots - image.width) / 2).clamp(0, paperWidthDots).toInt();

    List<int> bytes = [];

    // Initialize
    bytes.addAll([0x1B, 0x40]);

    // Center alignment (ESC a 1)
    bytes.addAll([0x1B, 0x61, 0x01]);

    // هامش علوي للفواتير (لورق الاستلام فقط)
    if (topBottomMargin > 0) {
      bytes.addAll([0x1B, 0x4A, topBottomMargin]);
    }

    // =========================
    // إنشاء Canvas بعرض الورق
    // =========================

    img.Image centeredImage = img.Image(
      width: paperWidthDots,
      height: contentHeight,
    );

    // تلوين الخلفية باللون الأبيض تماماً
    img.fill(
      centeredImage,
      color: img.ColorRgb8(255, 255, 255),
    );

    // لصق الباركود في منتصف الورقة برمجياً
    img.compositeImage(
      centeredImage,
      image,
      dstX: offsetX,
      dstY: -topMargin, // إزالة الهامش العلوي الزائد
    );

    int widthBytes = (centeredImage.width + 7) ~/ 8;

    // =========================
    // طباعة الصورة
    // =========================

    for (int y = 0; y < centeredImage.height; y += 24) {
      bytes.addAll([0x1D, 0x76, 0x30, 0x00]);

      bytes.add(widthBytes % 256);
      bytes.add(widthBytes ~/ 256);

      int chunkHeight =
          (y + 24 > centeredImage.height) ? centeredImage.height - y : 24;

      bytes.add(chunkHeight % 256);
      bytes.add(chunkHeight ~/ 256);

      for (int row = 0; row < chunkHeight; row++) {
        for (int x = 0; x < widthBytes; x++) {
          int byte = 0;

          for (int bit = 0; bit < 8; bit++) {
            int px = x * 8 + bit;

            if (px < centeredImage.width && y + row < centeredImage.height) {
              var pixel = centeredImage.getPixel(px, y + row);

              double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;

              if (val < 128) {
                byte |= (0x80 >> bit);
              }
            }
          }

          bytes.add(byte);
        }
      }
    }

    // هامش سفلي للورق المتصل (لورق الاستلام فقط)
    if (topBottomMargin > 0) {
      bytes.addAll([0x1B, 0x4A, topBottomMargin]);
    }

    // Feed
    bytes.addAll([0x1B, 0x64, 0x05]);

    // Cut
    bytes.addAll([0x1D, 0x56, 0x41, 0x00]);

    return bytes;
  }
}
