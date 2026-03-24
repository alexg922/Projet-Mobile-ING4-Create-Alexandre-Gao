import 'package:flutter/material.dart';
import 'package:formation_flutter/model/favorites_manager.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/error/product_page_error.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.barcode})
    : assert(barcode.length > 0);

  final String barcode;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    FavoritesManager().addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    FavoritesManager().removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return ChangeNotifierProvider<ProductFetcher>(
      create: (_) => ProductFetcher(barcode: widget.barcode),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer<ProductFetcher>(
              builder: (BuildContext context, ProductFetcher notifier, _) {
                return switch (notifier.state) {
                  ProductFetcherLoading() => const ProductPageEmpty(),
                  ProductFetcherError(error: var err) => ProductPageError(
                    error: err,
                  ),
                  ProductFetcherSuccess(product: var product) => _buildSuccess(context, notifier, product),
                };
              },
            ),
            // Back button
            PositionedDirectional(
              top: 0.0,
              start: 0.0,
              child: _HeaderIcon(
                icon: AppIcons.close,
                tooltip: materialLocalizations.closeButtonTooltip,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            // Favorite star button
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              child: Consumer<ProductFetcher>(
                builder: (context, notifier, _) {
                  final state = notifier.state;
                  if (state is ProductFetcherSuccess) {
                    final product = state.product;
                    final isFav = FavoritesManager().isFavorite(product.barcode);
                    return _HeaderIcon(
                      icon: isFav ? Icons.star : Icons.star_border,
                      tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                      onPressed: () {
                        FavoritesManager().toggleFavorite(product);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, ProductFetcher notifier, Product product) {
    return ProductPageBody();
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.tooltip, this.onPressed})
    : assert(tooltip.length > 0);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
