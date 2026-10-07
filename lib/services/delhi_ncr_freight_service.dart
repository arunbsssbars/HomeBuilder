import '../models/cart_item_model.dart';
import '../models/freight_quote_model.dart';

class DelhiNcrFreightService {
  const DelhiNcrFreightService();

  NcrZone detectZoneFromCityOrPincode(String location) {
    final lower = location.toLowerCase();
    if (lower.contains('noida') || lower.contains('ghaziabad') || lower.startsWith('201')) {
      return NcrZone.noida;
    }
    if (lower.contains('gurgaon') || lower.contains('gurugram') || lower.contains('faridabad') || lower.startsWith('122') || lower.startsWith('121')) {
      return NcrZone.gurgaon;
    }
    return NcrZone.delhi;
  }

  double calculateItemWeightTonnes(CartItemModel item) {
    final unit = item.product.unit.toLowerCase();
    final qty = item.quantity;

    if (unit.contains('bag')) {
      return qty * 0.05; // 50kg bag = 0.05 Tonnes
    } else if (unit.contains('kg')) {
      return qty * 0.001;
    } else if (unit.contains('ton')) {
      return qty * 1.0;
    } else if (unit.contains('piece') || unit.contains('brick') || unit.contains('block')) {
      return qty * 0.0035; // standard clay brick ~3.5kg
    } else {
      return qty * 0.01;
    }
  }

  CartFreightQuote calculateFreight({
    required List<CartItemModel> items,
    String destinationCity = 'Gurgaon',
  }) {
    if (items.isEmpty) {
      return const CartFreightQuote(
        vendorBreakdowns: [],
        totalDeliveryFreight: 0.0,
        destinationZone: NcrZone.gurgaon,
      );
    }

    final zone = detectZoneFromCityOrPincode(destinationCity);

    // Group items by vendor
    final Map<String, List<CartItemModel>> byVendor = {};
    final Map<String, String> vendorNames = {};

    for (final item in items) {
      byVendor.putIfAbsent(item.vendorId, () => []).add(item);
      vendorNames[item.vendorId] = item.vendorName;
    }

    final List<VendorFreightBreakdown> breakdowns = [];

    for (final entry in byVendor.entries) {
      final vendorId = entry.key;
      final vendorItems = entry.value;
      final vendorName = vendorNames[vendorId] ?? 'NCR Building Materials Depot';

      final totalWeight = vendorItems.fold<double>(
        0.0,
        (sum, item) => sum + calculateItemWeightTonnes(item),
      );

      double baseFreight;
      String vehicleType;

      if (totalWeight <= 1.0) {
        baseFreight = 600.0;
        vehicleType = 'Tata Ace (≤ 1.0 Tonne)';
      } else if (totalWeight <= 5.0) {
        baseFreight = 1400.0;
        vehicleType = '14ft Canter (1.0 - 5.0 Tonnes)';
      } else if (totalWeight <= 10.0) {
        baseFreight = 2800.0;
        vehicleType = '10-Tonne Tipper (5.0 - 10.0 Tonnes)';
      } else {
        baseFreight = 4500.0;
        vehicleType = 'Multi-Axle Heavy Trailer (> 10 Tonnes)';
      }

      final tollTax = zone.greenTax;
      final total = baseFreight + tollTax;

      breakdowns.add(
        VendorFreightBreakdown(
          vendorId: vendorId,
          vendorName: vendorName,
          totalWeightTonnes: totalWeight,
          vehicleType: vehicleType,
          baseTruckFreight: baseFreight,
          zoneTollTax: tollTax,
          totalFreight: total,
        ),
      );
    }

    final grandFreight = breakdowns.fold<double>(0.0, (sum, b) => sum + b.totalFreight);

    return CartFreightQuote(
      vendorBreakdowns: breakdowns,
      totalDeliveryFreight: grandFreight,
      destinationZone: zone,
    );
  }
}
