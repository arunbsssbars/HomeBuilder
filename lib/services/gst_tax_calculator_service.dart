import '../models/order_model.dart';
import '../models/tax_invoice_model.dart';

class GstTaxCalculatorService {
  const GstTaxCalculatorService();

  String getHsnSacCodeForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('cement')) return 'HSN 2523';
    if (lower.contains('steel') || lower.contains('iron')) return 'HSN 7214';
    if (lower.contains('brick') || lower.contains('aac') || lower.contains('block')) return 'HSN 6810';
    if (lower.contains('sand') || lower.contains('aggregate') || lower.contains('stone')) return 'HSN 2505';
    if (lower.contains('paint') || lower.contains('chemical')) return 'HSN 3208';
    if (lower.contains('service') || lower.contains('contract') || lower.contains('turnkey')) return 'SAC 9954';
    return 'HSN 9999';
  }

  double getGstRateForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('cement')) return 28.0;
    if (lower.contains('steel') || lower.contains('iron')) return 18.0;
    if (lower.contains('brick') || lower.contains('aac') || lower.contains('block')) return 12.0;
    if (lower.contains('sand') || lower.contains('aggregate')) return 5.0;
    if (lower.contains('paint')) return 18.0;
    if (lower.contains('service') || lower.contains('contract')) return 18.0;
    return 18.0;
  }

  GstTaxInvoice generateInvoiceForOrder({
    required OrderModel order,
    String sellerGstin = '06AAACA1234F1Z5',
    String sellerName = 'Delhi-NCR Building Materials Consortium Ltd.',
    String sellerState = 'Haryana',
    String buyerState = 'Haryana',
  }) {
    final isInterState = sellerState.toLowerCase() != buyerState.toLowerCase();

    final List<GstTaxLineItem> lineItems = [];

    for (final item in order.items) {
      final hsn = getHsnSacCodeForCategory(item.product.categoryName);
      final rate = getGstRateForCategory(item.product.categoryName);

      // Total item amount includes GST: Taxable = total / (1 + rate / 100)
      final gross = item.totalPrice;
      final taxable = gross / (1.0 + (rate / 100.0));
      final totalTax = gross - taxable;

      double cgst = 0.0;
      double sgst = 0.0;
      double igst = 0.0;

      if (isInterState) {
        igst = totalTax;
      } else {
        cgst = totalTax / 2.0;
        sgst = totalTax / 2.0;
      }

      lineItems.add(
        GstTaxLineItem(
          itemName: item.product.name,
          hsnSacCode: hsn,
          taxableAmount: taxable,
          gstRatePercent: rate,
          cgstAmount: cgst,
          sgstAmount: sgst,
          igstAmount: igst,
          totalAmount: gross,
        ),
      );
    }

    final totalTaxable = lineItems.fold<double>(0.0, (sum, i) => sum + i.taxableAmount);
    final totalCgst = lineItems.fold<double>(0.0, (sum, i) => sum + i.cgstAmount);
    final totalSgst = lineItems.fold<double>(0.0, (sum, i) => sum + i.sgstAmount);
    final totalIgst = lineItems.fold<double>(0.0, (sum, i) => sum + i.igstAmount);

    final cleanId = order.id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final irnHash = 'a4b7f9${cleanId.padRight(16, "0")}8d2e1c3f5a7b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3';

    return GstTaxInvoice(
      invoiceNumber: 'INV/2026-27/$cleanId',
      irnHash: irnHash,
      ackNumber: '11269084712',
      invoiceDate: order.createdAt,
      sellerGstin: sellerGstin,
      sellerLegalName: sellerName,
      buyerName: order.customerName,
      buyerGstin: null,
      placeOfSupply: buyerState,
      isInterState: isInterState,
      items: lineItems,
      totalTaxableValue: totalTaxable,
      totalCgst: totalCgst,
      totalSgst: totalSgst,
      totalIgst: totalIgst,
      grandInvoiceTotal: order.total,
    );
  }
}
