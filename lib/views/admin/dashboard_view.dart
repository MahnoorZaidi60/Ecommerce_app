import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/routes.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import '../../view_models/admin_vm.dart';
import 'orders_view.dart'; // Import the new file

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Manage Products"),
              Tab(icon: Icon(Icons.shopping_bag), text: "All Orders"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Exit Admin",
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
        ),

        body: const TabBarView(
          children: [
            _ProductsTab(),   // Defined below
            AdminOrdersView(), // Uses the new clean file
          ],
        ),
      ),
    );
  }
}

// Products Tab logic remains same (Keep inside this file or separate if you want)
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();
    final adminVM = Provider.of<AdminViewModel>(context);

    return StreamBuilder<List<ProductModel>>(
      stream: dbService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data ?? [];
        if (products.isEmpty) return const Center(child: Text("No products added yet."));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover,
                    placeholder: (_, __) => const Icon(Icons.image),
                  ),
                ),
                title: Text(product.name),
                subtitle: Text("${AppStrings.currency} ${product.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => adminVM.deleteProduct(product.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}