import 'package:flutter/material.dart';
import '../widget/categories/CategoriesHeader.dart';
import '../widget/categories/CategoriesStats.dart';
import '../widget/categories/CategoriesGrid.dart';
import '../widget/categories/RecentModificationsTable.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by MainLayout
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CategoriesHeader(),
            // CategoriesStats(),
            CategoriesGrid(),
            // RecentModificationsTable(),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
