/// Receipt data models for Fisly API

enum ReceiptStatus {
  uploaded(0),
  queued(1),
  processing(2),
  done(3),
  failed(4),
  parsed(5),
  processed(6),
  manualReview(7),
  quarantined(8);

  final int value;
  const ReceiptStatus(this.value);

  static ReceiptStatus fromInt(int value) {
    return ReceiptStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ReceiptStatus.uploaded,
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  return _parseInt(value);
}

class ReceiptUploadResponse {
  final String id;
  final int status;
  final String storedFileName;
  final String? receiptParsedId;

  ReceiptUploadResponse({
    required this.id,
    required this.status,
    required this.storedFileName,
    this.receiptParsedId,
  });

  factory ReceiptUploadResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptUploadResponse(
      id: json['id'] as String,
      status: _parseInt(json['status']),
      storedFileName: json['storedFileName'] as String,
      receiptParsedId: json['receiptParsedId'] as String?,
    );
  }
}

class ReceiptListResponse {
  final int page;
  final int pageSize;
  final int totalCount;
  final ReceiptSummary summary;
  final List<ReceiptListItem> items;

  ReceiptListResponse({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.summary,
    required this.items,
  });

  factory ReceiptListResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptListResponse(
      page: _parseInt(json['page']),
      pageSize: _parseInt(json['pageSize']),
      totalCount: _parseInt(json['totalCount']),
      summary: ReceiptSummary.fromJson(json['summary'] as Map<String, dynamic>),
      items: (json['items'] as List)
          .map((item) => ReceiptListItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ReceiptSummary {
  final int total;
  final int queued;
  final int processing;
  final int ready;
  final int failed;
  final int manualReview;
  final int quarantined;
  final String lastUpdatedAtUtc;

  ReceiptSummary({
    required this.total,
    required this.queued,
    required this.processing,
    required this.ready,
    required this.failed,
    required this.manualReview,
    required this.quarantined,
    required this.lastUpdatedAtUtc,
  });

  factory ReceiptSummary.fromJson(Map<String, dynamic> json) {
    return ReceiptSummary(
      total: _parseInt(json['total']),
      queued: _parseInt(json['queued']),
      processing: _parseInt(json['processing']),
      ready: _parseInt(json['ready']),
      failed: _parseInt(json['failed']),
      manualReview: _parseInt(json['manualReview']),
      quarantined: _parseInt(json['quarantined']),
      lastUpdatedAtUtc: json['lastUpdatedAtUtc'] as String,
    );
  }
}

class ReceiptListItem {
  final String receiptDocumentId;
  final String? receiptParsedId;
  final int status;
  final String? companyName;
  final String? receiptNo;
  final String? receiptDate;
  final double? amount;
  final String? currency;
  final String? documentType;
  final String storedFileName;
  final String uploadedAtUtc;
  final String? encryptedPayload;
  final bool encrypted;

  ReceiptListItem({
    required this.receiptDocumentId,
    this.receiptParsedId,
    required this.status,
    this.companyName,
    this.receiptNo,
    this.receiptDate,
    this.amount,
    this.currency,
    this.documentType,
    required this.storedFileName,
    required this.uploadedAtUtc,
    this.encryptedPayload,
    required this.encrypted,
  });

  factory ReceiptListItem.fromJson(Map<String, dynamic> json) {
    return ReceiptListItem(
      receiptDocumentId: json['receiptDocumentId'] as String,
      receiptParsedId: json['receiptParsedId'] as String?,
      status: _parseInt(json['status']),
      companyName: json['companyName'] as String?,
      receiptNo: json['receiptNo'] as String?,
      receiptDate: json['receiptDate'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      documentType: json['documentType'] as String?,
      storedFileName: json['storedFileName'] as String,
      uploadedAtUtc: json['uploadedAtUtc'] as String,
      encryptedPayload: json['encryptedPayload'] as String?,
      encrypted: json['encrypted'] as bool,
    );
  }
}

class ReceiptDetailResponse {
  final String receiptId;
  final String status;
  final bool encrypted;
  final String companyName;
  final String? taxOffice;
  final String? taxNumber;
  final String? date;
  final String? time;
  final double? subTotal;
  final double? vatTotal;
  final double? grandTotal;
  final String paymentType;
  final String decisionStatus;
  final double confidence;
  final String? encryptedPayload;
  final List<ReceiptItemDto> items;

  ReceiptDetailResponse({
    required this.receiptId,
    required this.status,
    required this.encrypted,
    required this.companyName,
    this.taxOffice,
    this.taxNumber,
    this.date,
    this.time,
    this.subTotal,
    this.vatTotal,
    this.grandTotal,
    required this.paymentType,
    required this.decisionStatus,
    required this.confidence,
    this.encryptedPayload,
    required this.items,
  });

  factory ReceiptDetailResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptDetailResponse(
      receiptId: json['receiptId'] as String,
      status: json['status'] as String,
      encrypted: json['encrypted'] as bool,
      companyName: json['companyName'] as String,
      taxOffice: json['taxOffice'] as String?,
      taxNumber: json['taxNumber'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      vatTotal: (json['vatTotal'] as num?)?.toDouble(),
      grandTotal: (json['grandTotal'] as num?)?.toDouble(),
      paymentType: json['paymentType'] as String,
      decisionStatus: json['decisionStatus'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      encryptedPayload: json['encryptedPayload'] as String?,
      items: (json['items'] as List)
          .map((item) => ReceiptItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ReceiptItemDto {
  final String name;
  final int vatRate;
  final double price;

  ReceiptItemDto({
    required this.name,
    required this.vatRate,
    required this.price,
  });

  factory ReceiptItemDto.fromJson(Map<String, dynamic> json) {
    return ReceiptItemDto(
      name: json['name'] as String,
      vatRate: _parseInt(json['vatRate']),
      price: (json['price'] as num).toDouble(),
    );
  }
}

class ReceiptManualViewDto {
  final bool manualRequired;
  final List<String> missingFields;
  final String status;
  final ReceiptManualValuesDto values;

  ReceiptManualViewDto({
    required this.manualRequired,
    required this.missingFields,
    required this.status,
    required this.values,
  });

  factory ReceiptManualViewDto.fromJson(Map<String, dynamic> json) {
    return ReceiptManualViewDto(
      manualRequired: json['manual_required'] as bool,
      missingFields: (json['missing_fields'] as List).cast<String>(),
      status: json['status'] as String,
      values: ReceiptManualValuesDto.fromJson(
        json['values'] as Map<String, dynamic>,
      ),
    );
  }
}

class ReceiptManualValuesDto {
  final String? companyName;
  final String? taxOffice;
  final String? taxNumber;
  final String? receiptDate;
  final String? receiptTime;
  final double? grossTotal;
  final double? vatTotal;
  final double? netTotal;
  final String? paymentType;

  ReceiptManualValuesDto({
    this.companyName,
    this.taxOffice,
    this.taxNumber,
    this.receiptDate,
    this.receiptTime,
    this.grossTotal,
    this.vatTotal,
    this.netTotal,
    this.paymentType,
  });

  factory ReceiptManualValuesDto.fromJson(Map<String, dynamic> json) {
    return ReceiptManualValuesDto(
      companyName: json['company_name'] as String?,
      taxOffice: json['tax_office'] as String?,
      taxNumber: json['tax_number'] as String?,
      receiptDate: json['receipt_date'] as String?,
      receiptTime: json['receipt_time'] as String?,
      grossTotal: (json['gross_total'] as num?)?.toDouble(),
      vatTotal: (json['vat_total'] as num?)?.toDouble(),
      netTotal: (json['net_total'] as num?)?.toDouble(),
      paymentType: json['payment_type'] as String?,
    );
  }
}

class ReceiptManualUpdateRequest {
  final String? companyName;
  final String? taxOffice;
  final String? taxNumber;
  final String? receiptDate;
  final String? receiptTime;
  final double? grossTotal;
  final double? vatTotal;
  final double? netTotal;
  final String? paymentType;

  ReceiptManualUpdateRequest({
    this.companyName,
    this.taxOffice,
    this.taxNumber,
    this.receiptDate,
    this.receiptTime,
    this.grossTotal,
    this.vatTotal,
    this.netTotal,
    this.paymentType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (companyName != null) data['company_name'] = companyName;
    if (taxOffice != null) data['tax_office'] = taxOffice;
    if (taxNumber != null) data['tax_number'] = taxNumber;
    if (receiptDate != null) data['receipt_date'] = receiptDate;
    if (receiptTime != null) data['receipt_time'] = receiptTime;
    if (grossTotal != null) data['gross_total'] = grossTotal;
    if (vatTotal != null) data['vat_total'] = vatTotal;
    if (netTotal != null) data['net_total'] = netTotal;
    if (paymentType != null) data['payment_type'] = paymentType;
    return data;
  }
}

class ReceiptManualEditDto {
  final String id;
  final String editedAtUtc;
  final String source;
  final String editedByUserId;
  final String beforeJson;
  final String afterJson;

  ReceiptManualEditDto({
    required this.id,
    required this.editedAtUtc,
    required this.source,
    required this.editedByUserId,
    required this.beforeJson,
    required this.afterJson,
  });

  factory ReceiptManualEditDto.fromJson(Map<String, dynamic> json) {
    return ReceiptManualEditDto(
      id: json['id'] as String,
      editedAtUtc: json['editedAtUtc'] as String,
      source: json['source'] as String,
      editedByUserId: json['editedByUserId'] as String,
      beforeJson: json['beforeJson'] as String,
      afterJson: json['afterJson'] as String,
    );
  }
}

class CustomerInfo {
  final String id;
  final String fullName;
  final String email;
  final String? companyName;
  final bool isActive;
  final int? receiptCount;
  final String? lastReceiptDate;

  CustomerInfo({
    required this.id,
    required this.fullName,
    required this.email,
    this.companyName,
    required this.isActive,
    this.receiptCount,
    this.lastReceiptDate,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      companyName: json['companyName'] as String?,
      isActive: json['isActive'] as bool,
      receiptCount: _parseNullableInt(json['receiptCount']),
      lastReceiptDate: json['lastReceiptDate'] as String?,
    );
  }
}

class AssignCustomerResponse {
  final bool assigned;
  final bool already;

  AssignCustomerResponse({required this.assigned, required this.already});

  factory AssignCustomerResponse.fromJson(Map<String, dynamic> json) {
    return AssignCustomerResponse(
      assigned: json['assigned'] as bool,
      already: json['already'] as bool,
    );
  }
}

class AccountantInfo {
  final String id;
  final String fullName;
  final String email;
  final String? companyName;

  AccountantInfo({
    required this.id,
    required this.fullName,
    required this.email,
    this.companyName,
  });

  factory AccountantInfo.fromJson(Map<String, dynamic> json) {
    return AccountantInfo(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      companyName: json['companyName'] as String?,
    );
  }
}

class SendToAccountingResponse {
  final bool ok;

  SendToAccountingResponse({required this.ok});

  factory SendToAccountingResponse.fromJson(Map<String, dynamic> json) {
    return SendToAccountingResponse(ok: json['ok'] as bool);
  }
}
