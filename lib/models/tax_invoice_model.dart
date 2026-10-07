class GstTaxLineItem {
  final String itemName;
  final String hsnSacCode;
  final double taxableAmount;
  final double gstRatePercent;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final double totalAmount;

  const GstTaxLineItem({
    required this.itemName,
    required this.hsnSacCode,
    required this.taxableAmount,
    required this.gstRatePercent,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,
    required this.totalAmount,
  });
}

class GstTaxInvoice {
  final String invoiceNumber;
  final String irnHash;
  final String ackNumber;
  final DateTime invoiceDate;
  final String sellerGstin;
  final String sellerLegalName;
  final String buyerName;
  final String? buyerGstin;
  final String placeOfSupply;
  final bool isInterState;
  final List<GstTaxLineItem> items;
  final double totalTaxableValue;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final double grandInvoiceTotal;

  const GstTaxInvoice({
    required this.invoiceNumber,
    required this.irnHash,
    required this.ackNumber,
    required this.invoiceDate,
    required this.sellerGstin,
    required this.sellerLegalName,
    required this.buyerName,
    this.buyerGstin,
    required this.placeOfSupply,
    required this.isInterState,
    required this.items,
    required this.totalTaxableValue,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalIgst,
    required this.grandInvoiceTotal,
  });
}
