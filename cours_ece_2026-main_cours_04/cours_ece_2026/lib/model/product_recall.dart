/// Model for a product recall (Rappel produit)
class ProductRecall {
  final String? productName;
  final String? imageUrl;
  final String? dateStart;
  final String? dateEnd;
  final String? distributors;
  final String? geographicZone;
  final String? recallReason;
  final String? risksDescription;
  final String? substancesDangereuses;
  final String? linkUrl;

  ProductRecall({
    this.productName,
    this.imageUrl,
    this.dateStart,
    this.dateEnd,
    this.distributors,
    this.geographicZone,
    this.recallReason,
    this.risksDescription,
    this.substancesDangereuses,
    this.linkUrl,
  });

  factory ProductRecall.fromJson(Map<String, dynamic> json) {
    return ProductRecall(
      productName: json['productName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      dateStart: json['dateStart'] as String?,
      dateEnd: json['dateEnd'] as String?,
      distributors: json['distributors'] as String?,
      geographicZone: json['geographicZone'] as String?,
      recallReason: json['recallReason'] as String?,
      risksDescription: json['risksDescription'] as String?,
      substancesDangereuses: json['substancesDangereuses'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );
  }

  /// Create a sample recall for demonstration
  static ProductRecall sample({
    required String productName,
    required String? imageUrl,
  }) {
    return ProductRecall(
      productName: productName,
      imageUrl: imageUrl,
      dateStart: '27/10/2025',
      dateEnd: '29/01/2026',
      distributors:
          'ALDI - AUCHAN - CARREFOUR - CASINO - CORA - '
          'INTERMARCHE - LECLERC - LIDL - MONOPRIX - SCHIEVER '
          '- SYSTÈME U Ainsi que les réseaux de distribution hors domicile.',
      geographicZone: 'France entière',
      recallReason:
          'Ce rappel est mis en œuvre par mesure de précaution afin '
          'de protéger les personnes allergiques au lait, absent sur la '
          'liste d\'ingrédients. Il existe '
          'de ce fait un risque pour les personnes allergiques au LAIT.',
      risksDescription: 'Substances allergisantes non déclarées',
      substancesDangereuses: 'Lait',
      linkUrl: 'https://rappel.conso.gouv.fr',
    );
  }
}
