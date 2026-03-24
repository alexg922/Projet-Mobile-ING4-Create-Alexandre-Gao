import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product_recall.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class RecallScreen extends StatelessWidget {
  const RecallScreen({super.key, required this.recall});

  final ProductRecall recall;

  void _onShare(BuildContext context) {
    final String text =
        'Rappel produit : ${recall.productName ?? "Produit"}\n'
        '${recall.linkUrl ?? "https://rappel.conso.gouv.fr"}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
          'Rappel produit',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _onShare(context),
            icon: const Icon(Icons.share, color: AppColors.blue, size: 24),
            tooltip: 'Partager',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Product image
            if (recall.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    recall.imageUrl!,
                    width: 188,
                    height: 181,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 188,
                      height: 181,
                      color: AppColors.grey1,
                      child: Icon(Icons.image_not_supported,
                          color: AppColors.grey2, size: 50),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Dates de commercialisation
            if (recall.dateStart != null || recall.dateEnd != null)
              _RecallSection(
                title: 'Dates de commercialisation',
                content: _buildDateContent(),
              ),

            // Distributeurs
            if (recall.distributors != null)
              _RecallSection(
                title: 'Distributeurs',
                content: recall.distributors!,
              ),

            // Zone géographique
            if (recall.geographicZone != null)
              _RecallSection(
                title: 'Zone géographique',
                content: recall.geographicZone!,
              ),

            // Motif du rappel
            if (recall.recallReason != null)
              _RecallSection(
                title: 'Motif du rappel',
                content: recall.recallReason!,
              ),

            // Risques encourus
            if (recall.risksDescription != null)
              _RecallSection(
                title: 'Risques encourus',
                content: recall.risksDescription!,
              ),

            // Substances dangereuses
            if (recall.substancesDangereuses != null)
              _RecallSection(
                title: 'Substances dangereuses',
                content: recall.substancesDangereuses!,
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _buildDateContent() {
    if (recall.dateStart != null && recall.dateEnd != null) {
      return 'Du ${recall.dateStart} au ${recall.dateEnd}';
    } else if (recall.dateStart != null) {
      return 'À partir du ${recall.dateStart}';
    } else {
      return 'Jusqu\'au ${recall.dateEnd}';
    }
  }
}

class _RecallSection extends StatelessWidget {
  const _RecallSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      color: const Color(0xFFF5F4F4),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              content,
              textAlign: TextAlign.center,
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
