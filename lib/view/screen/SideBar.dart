import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/Colorapp.dart';
import '../../controller/HomeScreen/SiedBarController.dart';
import '../../core/constant/imageassets.dart';
import '../../core/localizations/ChengeLocal.dart';
import '../widget/user_profile_dialog.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final isSidebarExpanded = controller.isSidebarExpanded.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isSidebarExpanded ? 280 : 85,
        decoration: BoxDecoration(
          color: isDark ? AppColor.sidebarDark : AppColor.sidebarLight,
          border: Border(
            left: BorderSide(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Sidebar Header
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                child: IconButton(
                  onPressed: controller.toggleSidebarSize,
                  icon: Icon(
                    isSidebarExpanded ? Icons.menu_open_rounded : Icons.menu_rounded,
                    color: AppColor.primaryPurple,
                  ),
                ),
              ),
            ),
            if (isSidebarExpanded)
              Padding(
                padding: const EdgeInsets.only(
                  right: 24.0,
                  left: 24.0,
                  bottom: 30.0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'app_name'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColor.primaryPurple,
                        ),
                      ),
                      Text(
                        'system_management'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColor.textSecondary
                              : Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(height: 20),

            // Menu Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.screens.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final screen = controller.screens[index];
                  final List subPages = screen['subPages'] ?? [];

                  return Obx(() {
                    final isSelected = controller.currentPage.value == index;
                    final isExpanded = controller.expandedIndex.value == index;

                    if (subPages.isEmpty) {
                      return _buildMainItem(controller, index, screen, isSelected, isDark);
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMainItem(controller, index, screen, isSelected, isDark, 
                              hasSubPages: true, 
                              isExpanded: isExpanded,
                              onExpandToggle: () => controller.toggleExpand(index)),
                          if (isExpanded)
                            ...subPages.asMap().entries.map((subEntry) {
                              final subIndex = subEntry.key;
                              final subPage = subEntry.value;
                              final isSubSelected = controller.currentSubIndex.value == subIndex && isSelected;
                              
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: _buildSubItem(controller, index, subIndex, subPage, isSubSelected, isDark),
                              );
                            }).toList(),
                        ],
                      );
                    }
                  });
                },
              ),
            ),

            // Sidebar Footer
            Padding(
              padding: EdgeInsets.all(isSidebarExpanded ? 24.0 : 12.0),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: AppColor.purpleGradient,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryPurple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: isSidebarExpanded ? null : EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSidebarExpanded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'add_sales'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      : const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMainItem(Siedbarcontroller controller, int index, Map screen, bool isSelected, bool isDark, {bool hasSubPages = false, bool isExpanded = false, VoidCallback? onExpandToggle}) {
    final isSidebarExpanded = controller.isSidebarExpanded.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(colors: AppColor.purpleGradient)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (hasSubPages) {
            if (!isSidebarExpanded) {
              controller.toggleSidebarSize();
            }
            if (onExpandToggle != null) onExpandToggle();
          } else {
            controller.changePage(index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSidebarExpanded ? 16 : 0, vertical: 14),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: isSidebarExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                screen['icon'],
                color: isSelected ? Colors.white : (isDark ? AppColor.textDark : const Color(0xFF8E92BC)),
                size: 22,
              ),
              if (isSidebarExpanded) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    screen['name'].toString().tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : (isDark ? AppColor.textDark : const Color(0xFF5D596C)),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                if (hasSubPages)
                  Icon(
                    isExpanded ? Icons.expand_more_rounded : Icons.chevron_left_rounded,
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 20,
                  ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubItem(Siedbarcontroller controller, int parentIndex, int subIndex, Map subPage, bool isSelected, bool isDark) {
    final isSidebarExpanded = controller.isSidebarExpanded.value;
    return InkWell(
      onTap: () {
        controller.currentPage.value = parentIndex;
        controller.changeSubPage(subIndex, subPage['page']);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.only(right: isSidebarExpanded ? 32 : 0),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryPurple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: AppColor.primaryPurple.withOpacity(0.2)) : null,
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: isSidebarExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(
              subPage['icon'],
              color: isSelected ? AppColor.primaryPurple : (isDark ? Colors.white38 : Colors.grey),
              size: 18,
            ),
            if (isSidebarExpanded) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subPage['name'].toString().tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColor.primaryPurple : (isDark ? Colors.white38 : Colors.grey.shade600),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Siedbarcontroller());

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1200;
        return Obx(() {
          final isDark = controller.isDarkMode.value;
          return Scaffold(
            backgroundColor: isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
            drawer: isMobile ? const Drawer(child: SidebarWidget()) : null,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  if (!isMobile) const SidebarWidget(),
                  Expanded(
                    child: Column(
                      children: [
                        TopBar(isMobile: isMobile),
                        Expanded(
                          child: Obx(() {
                            if (controller.currentSubPage.value != null && controller.expandedIndex.value != null) {
                               return controller.currentSubPage.value!();
                            }
                            final screen = controller.screens[controller.currentPage.value];
                            return screen['page'] != null ? screen['page']() : const Center(child: Text('Page Not Found'));
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class TopBar extends StatelessWidget {
  final bool isMobile;
  const TopBar({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);

      return Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(32, 24, 32, 0),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            if (isMobile)
              IconButton(icon: const Icon(Icons.menu, color: AppColor.primaryPurple), onPressed: () => Scaffold.of(context).openDrawer()),

            // Search Field
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                textAlign: TextAlign.right,
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'search_system'.tr,
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
              ),
            ),

            const Spacer(),

            _buildTopButton(onPressed: () => controller.toggleDarkMode(), icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, isDark: isDark),
            const SizedBox(width: 12),
            _buildLanguageToggle(isDark),
            const SizedBox(width: 12),
            _buildTopButton(onPressed: () {}, icon: Icons.notifications_none_rounded, hasBadge: true, isDark: isDark),
            const SizedBox(width: 20),

            // Profile Section
            InkWell(
              onTap: () {
                Get.dialog(const UserProfileDialog());
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.name.value.isEmpty ? "mock_user_name".tr : controller.name.value,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor, fontFamily: 'Cairo')
                        ),
                        Text(
                          controller.hallname.value.isEmpty ? "mock_user_role".tr : controller.hallname.value,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      backgroundImage: () {
                        final path = controller.imagePath.value;
                        if (path != null && path.isNotEmpty && !path.startsWith('http') && File(path).existsSync()) {
                          return FileImage(File(path)) as ImageProvider;
                        }
                        return const AssetImage(Appimageassets.avater);
                      }()
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLanguageToggle(bool isDark) {
    final LocalController localeController = Get.find<LocalController>();
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangOption(label: "AR", isActive: isArabic, isDark: isDark, onTap: () => localeController.changeLang("ar")),
          const SizedBox(width: 2),
          _buildLangOption(label: "EN", isActive: !isArabic, isDark: isDark, onTap: () => localeController.changeLang("en")),
        ],
      ),
    );
  }

  Widget _buildLangOption({required String label, required bool isActive, required bool isDark, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : (isDark ? Colors.white30 : Colors.black26), fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildTopButton({required VoidCallback onPressed, required IconData icon, bool hasBadge = false, bool isDark = false}) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 22),
        ),
        if (hasBadge)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: isDark ? AppColor.surfaceDark : Colors.white, width: 1.5)),
            ),
          ),
      ],
    );
  }
}
