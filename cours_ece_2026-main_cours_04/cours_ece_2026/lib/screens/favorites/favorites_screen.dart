import 'package:flutter/material.dart';
import 'package:formation_flutter/model/favorites_manager.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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

  Color _nutriscoreColor(ProductNutriScore score) {
    return switch (score) {
      ProductNutriScore.A => AppColors.nutriscoreA,
      ProductNutriScore.B => AppColors.nutriscoreB,
      ProductNutriScore.C => AppColors.nutriscoreC,
      ProductNutriScore.D => AppColors.nutriscoreD,
      ProductNutriScore.E => AppColors.nutriscoreE,
      ProductNutriScore.unknown => AppColors.grey2,
    };
  }

  String _nutriscoreLabel(ProductNutriScore score) {
    return switch (score) {
      ProductNutriScore.A => 'A',
      ProductNutriScore.B => 'B',
      ProductNutriScore.C => 'C',
      ProductNutriScore.D => 'D',
      ProductNutriScore.E => 'E',
      ProductNutriScore.unknown => '?',
    };
  }

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager().favorites;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        toolbarHeight: 54,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.blue, size: 24),
        ),
        title: const Text(
          'Mes favoris',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(favorites),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 80, color: AppColors.grey2),
          const SizedBox(height: 16),
          Text(
            'Aucun favori pour le moment',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 16,
              color: AppColors.grey3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des produits à vos favoris\ndepuis la page produit',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 13,
              color: AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Product> favorites) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        final score = product.nutriScore ?? ProductNutriScore.unknown;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 1,
            child: InkWell(
              onTap: () => context.push('/product', extra: product.barcode),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.picture != null
                          ? Image.network(
                              product.picture!,
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 95,
                                height: 95,
                                color: AppColors.grey1,
                                child: Icon(Icons.image_not_supported,
                                    color: AppColors.grey2, size: 40),
                              ),
                            )
                          : Container(
                              width: 95,
                              height: 95,
                              color: AppColors.grey1,
                              child: Icon(Icons.image_not_supported,
                                  color: AppColors.grey2, size: 40),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? 'Produit inconnu',
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.brands?.join(', ') ?? '',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 13,
                              color: AppColors.grey3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _nutriscoreColor(score),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Nutriscore : ${_nutriscoreLabel(score)}',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
