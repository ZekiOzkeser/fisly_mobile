import 'package:image_picker/image_picker.dart';
import '../domain/receipt.dart';
import '../domain/receipt_category.dart';

abstract class ReceiptsRepository {
  Future<List<Receipt>> listByMonth(String month);
  Future<Receipt> getById(String id);

  Future<Receipt> update({
    required String id,
    ReceiptCategory? category,
    String? note,
  });

  // NEW: upload
  Future<Receipt> upload({
    required String month,
    XFile? image,
    String? pdfPath,
  });
}
