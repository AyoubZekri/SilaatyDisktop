import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/Colorapp.dart';
import './NotificationCard.dart';

class NotificationList extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;

  const NotificationList({
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationCard(
          isDark: isDark,
          surfaceColor: surfaceColor,
          textColor: textColor,
          subTextColor: subTextColor,
          title: "new_sale_success".tr,
          desc:
              "تم تأكيد طلب جديد بقيمة 12,450 ر.س من فرع الرياض. العميل: شركة الأفق المعماري.",
          time: "mins_ago".trArgs(["5"]),
          icon: Icons.shopping_cart_outlined,
          iconColor: AppColor.primaryPurple,
          hasBadge: true,
        ),
        const SizedBox(height: 16),
        NotificationCard(
          isDark: isDark,
          surfaceColor: surfaceColor,
          textColor: textColor,
          subTextColor: subTextColor,
          title: "low_stock_alert".tr,
          desc:
              "وصل مخزون \"شاشات ألترا برو 32\" إلى الحد الأدنى (5 قطع متبقية). يرجى طلب توريد جديد فوراً.",
          time: "hour_ago".tr,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          hasBadge: false,
        ),
        const SizedBox(height: 16),
        NotificationCard(
          isDark: isDark,
          surfaceColor: surfaceColor,
          textColor: textColor,
          subTextColor: subTextColor,
          title: "branch_update".tr,
          desc:
              "قام مدير فرع جدة بتحديث ساعات العمل الرسمية وإضافة طاقم عمل جديد لقسم المبيعات.",
          time: "hours_ago".trArgs(["3"]),
          icon: Icons.store_outlined,
          iconColor: Colors.blue,
          hasBadge: true,
        ),
        const SizedBox(height: 16),
        NotificationCard(
          isDark: isDark,
          surfaceColor: surfaceColor,
          textColor: textColor,
          subTextColor: subTextColor,
          title: "security_update".tr,
          desc:
              "تم الانتهاء من ترقية البروتوكولات الأمنية لقاعدة البيانات السحابية. لا يتطلب أي إجراء من قبلك.",
          time: "yesterday".tr,
          icon: Icons.security_outlined,
          iconColor: Colors.indigo,
          hasBadge: false,
        ),
      ],
    );
  }
}
