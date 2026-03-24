import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/homepage_list.dart';
import 'package:formation_flutter/screens/favorites/favorites_screen.dart';
import 'package:formation_flutter/screens/scanner/barcode_scanner_screen.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> _scanHistory = [];
  bool _isLoading = false;

  Future<void> _onScanButtonPressed() async {
    final String? barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (barcode == null || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final product = await OpenFoodFactsAPI().getProduct(barcode);
      if (mounted) {
        setState(() {
          _scanHistory.insert(0, product);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du produit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onLogout() {
    PocketBaseAPI().logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final bool hasHistory = _scanHistory.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        toolbarHeight: 54,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          localizations.my_scans_screen_title,
          style: const TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        actions: <Widget>[
          // Barcode icon — visible only when history exists
          if (hasHistory)
            IconButton(
              onPressed: _isLoading ? null : _onScanButtonPressed,
              icon: Icon(AppIcons.barcode, color: AppColors.blue, size: 24),
              tooltip: 'Scanner',
            ),

          // Star icon — favorites
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
            icon: const Icon(Icons.star, color: AppColors.blue, size: 24),
            tooltip: 'Favoris',
          ),

          // Logout icon
          IconButton(
            onPressed: _onLogout,
            icon: const Icon(Icons.exit_to_app, color: AppColors.blue, size: 24),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
              ),
            )
          : hasHistory
              ? HomePageList(products: _scanHistory)
              : HomePageEmpty(onScan: _onScanButtonPressed),
    );
  }
}
