enum ReceiptCategory { food, transport, office, accommodation, other }

extension ReceiptCategoryX on ReceiptCategory {
  String get key => name;

  String get label => switch (this) {
    ReceiptCategory.food => 'Yemek',
    ReceiptCategory.transport => 'Ulaşım',
    ReceiptCategory.office => 'Ofis',
    ReceiptCategory.accommodation => 'Konaklama',
    ReceiptCategory.other => 'Diğer',
  };

  static ReceiptCategory? fromKey(String? key) {
    if (key == null) return null;
    for (final c in ReceiptCategory.values) {
      if (c.key == key) return c;
    }
    return null;
  }
}
