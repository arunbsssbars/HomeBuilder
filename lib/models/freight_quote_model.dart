enum NcrZone {
  delhi(name: 'Delhi NCT', greenTax: 350.0),
  gurgaon(name: 'Gurgaon / Faridabad (Haryana)', greenTax: 250.0),
  noida(name: 'Noida / Ghaziabad (UP)', greenTax: 300.0);

  final String name;
  final double greenTax;

  const NcrZone({required this.name, required this.greenTax});
}

class VendorFreightBreakdown {
  final String vendorId;
  final String vendorName;
  final double totalWeightTonnes;
  final String vehicleType;
  final double baseTruckFreight;
  final double zoneTollTax;
  final double totalFreight;

  const VendorFreightBreakdown({
    required this.vendorId,
    required this.vendorName,
    required this.totalWeightTonnes,
    required this.vehicleType,
    required this.baseTruckFreight,
    required this.zoneTollTax,
    required this.totalFreight,
  });
}

class CartFreightQuote {
  final List<VendorFreightBreakdown> vendorBreakdowns;
  final double totalDeliveryFreight;
  final NcrZone destinationZone;

  const CartFreightQuote({
    required this.vendorBreakdowns,
    required this.totalDeliveryFreight,
    required this.destinationZone,
  });
}
