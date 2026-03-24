import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

/// Tab 1: Caractéristiques — Ingrédients, Allergènes, Additifs
class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ingrédients section
          _SectionTitle(title: 'Ingrédients'),
          const SizedBox(height: 8),
          if (product.ingredients != null && product.ingredients!.isNotEmpty)
            ...product.ingredients!.map(
              (ingredient) => _IngredientRow(ingredient: ingredient),
            )
          else
            const _EmptyRow(text: 'Aucune donnée disponible'),

          const SizedBox(height: 24),

          // Allergènes section
          _SectionTitle(title: 'Substances allergènes'),
          const SizedBox(height: 8),
          if (product.allergens != null && product.allergens!.isNotEmpty)
            ...product.allergens!.map(
              (allergen) => _SimpleRow(text: allergen),
            )
          else
            const _EmptyRow(text: 'Aucune'),

          const SizedBox(height: 24),

          // Additifs section
          _SectionTitle(title: 'Additifs'),
          const SizedBox(height: 8),
          if (product.additives != null && product.additives!.isNotEmpty)
            ...product.additives!.entries.map(
              (entry) => _AdditiveRow(code: entry.key, name: entry.value),
            )
          else
            const _EmptyRow(text: 'Aucune'),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient});
  final String ingredient;

  @override
  Widget build(BuildContext context) {
    // Parse ingredient — look for parentheses content
    final regex = RegExp(r'^(.+?)(\s*\(.*\))$');
    final match = regex.firstMatch(ingredient);

    final String name = match != null ? match.group(1)!.trim() : ingredient;
    final String? details = match?.group(2)?.trim();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Avenir',
                fontSize: 14,
                color: AppColors.blue,
              ),
            ),
          ),
          if (details != null)
            Expanded(
              child: Text(
                details,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 13,
                  color: AppColors.grey3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Avenir',
          fontSize: 14,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _AdditiveRow extends StatelessWidget {
  const _AdditiveRow({required this.code, required this.name});
  final String code;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            code.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Avenir',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 13,
                color: AppColors.grey3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Avenir',
          fontSize: 14,
          color: AppColors.grey3,
        ),
      ),
    );
  }
}
