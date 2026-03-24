import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

/// Tab 2: Nutrition — Fat, Saturated fat, Sugars, Salt with color levels
/// Thresholds from: https://fr.openfoodfacts.org/reperes-nutritionnels
class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutrientLevels = product.nutrientLevels;
    final nutritionFacts = product.nutritionFacts;

    if (nutrientLevels == null && nutritionFacts == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Données nutritionnelles non disponibles',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 14,
            color: AppColors.grey3,
          ),
        ),
      );
    }

    // Get values from nutritionFacts per100g
    final double? fatValue = nutritionFacts?.fat?.per100g is num
        ? (nutritionFacts!.fat!.per100g as num).toDouble()
        : null;
    final double? saturatedFatValue = nutritionFacts?.saturatedFat?.per100g is num
        ? (nutritionFacts!.saturatedFat!.per100g as num).toDouble()
        : null;
    final double? sugarsValue = nutritionFacts?.sugar?.per100g is num
        ? (nutritionFacts!.sugar!.per100g as num).toDouble()
        : null;
    final double? saltValue = nutritionFacts?.salt?.per100g is num
        ? (nutritionFacts!.salt!.per100g as num).toDouble()
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Repères nutritionnels pour 100g',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 14,
              color: AppColors.grey3,
            ),
          ),
          const SizedBox(height: 20),

          // Fat
          _NutrientBlock(
            label: 'Matières grasses / lipides',
            value: fatValue,
            unit: nutritionFacts?.fat?.unit ?? 'g',
            level: _getFatLevel(fatValue),
          ),
          const SizedBox(height: 12),

          // Saturated fat
          _NutrientBlock(
            label: 'Acides gras saturés',
            value: saturatedFatValue,
            unit: nutritionFacts?.saturatedFat?.unit ?? 'g',
            level: _getSaturatedFatLevel(saturatedFatValue),
          ),
          const SizedBox(height: 12),

          // Sugars
          _NutrientBlock(
            label: 'Sucres',
            value: sugarsValue,
            unit: nutritionFacts?.sugar?.unit ?? 'g',
            level: _getSugarsLevel(sugarsValue),
          ),
          const SizedBox(height: 12),

          // Salt
          _NutrientBlock(
            label: 'Sel',
            value: saltValue,
            unit: nutritionFacts?.salt?.unit ?? 'g',
            level: _getSaltLevel(saltValue),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Thresholds based on https://fr.openfoodfacts.org/reperes-nutritionnels
  /// Fat: low ≤3g, moderate ≤20g, high >20g
  _NutrientLevel _getFatLevel(double? value) {
    if (value == null) return _NutrientLevel.unknown;
    if (value <= 3) return _NutrientLevel.low;
    if (value <= 20) return _NutrientLevel.moderate;
    return _NutrientLevel.high;
  }

  /// Saturated fat: low ≤1.5g, moderate ≤5g, high >5g
  _NutrientLevel _getSaturatedFatLevel(double? value) {
    if (value == null) return _NutrientLevel.unknown;
    if (value <= 1.5) return _NutrientLevel.low;
    if (value <= 5) return _NutrientLevel.moderate;
    return _NutrientLevel.high;
  }

  /// Sugars: low ≤5g, moderate ≤12.5g, high >12.5g
  _NutrientLevel _getSugarsLevel(double? value) {
    if (value == null) return _NutrientLevel.unknown;
    if (value <= 5) return _NutrientLevel.low;
    if (value <= 12.5) return _NutrientLevel.moderate;
    return _NutrientLevel.high;
  }

  /// Salt: low ≤0.3g, moderate ≤1.5g, high >1.5g
  _NutrientLevel _getSaltLevel(double? value) {
    if (value == null) return _NutrientLevel.unknown;
    if (value <= 0.3) return _NutrientLevel.low;
    if (value <= 1.5) return _NutrientLevel.moderate;
    return _NutrientLevel.high;
  }
}

enum _NutrientLevel { low, moderate, high, unknown }

class _NutrientBlock extends StatelessWidget {
  const _NutrientBlock({
    required this.label,
    required this.value,
    required this.unit,
    required this.level,
  });

  final String label;
  final double? value;
  final String unit;
  final _NutrientLevel level;

  Color get _color => switch (level) {
    _NutrientLevel.low => AppColors.nutriscoreA, // green
    _NutrientLevel.moderate => AppColors.nutriscoreC, // yellow/orange
    _NutrientLevel.high => AppColors.nutriscoreE, // red
    _NutrientLevel.unknown => AppColors.grey2,
  };

  String get _levelLabel => switch (level) {
    _NutrientLevel.low => 'Faible quantité',
    _NutrientLevel.moderate => 'Quantité modérée',
    _NutrientLevel.high => 'Quantité élevée',
    _NutrientLevel.unknown => 'Données non disponibles',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.blue,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value != null ? '${value!.toStringAsFixed(value! == value!.truncateToDouble() ? 0 : 1)}$unit' : '?',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: _color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _levelLabel,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: _color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
