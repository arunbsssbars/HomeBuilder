import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/boq_estimate_model.dart';
import '../models/product_model.dart';
import '../services/boq_estimator_service.dart';
import 'cart_provider.dart';

class BOQState {
  final double plotAreaSqFt;
  final int numberOfFloors;
  final ConstructionQualityTier qualityTier;
  final BOQEstimateResult estimate;

  const BOQState({
    required this.plotAreaSqFt,
    required this.numberOfFloors,
    required this.qualityTier,
    required this.estimate,
  });

  BOQState copyWith({
    double? plotAreaSqFt,
    int? numberOfFloors,
    ConstructionQualityTier? qualityTier,
    BOQEstimateResult? estimate,
  }) {
    return BOQState(
      plotAreaSqFt: plotAreaSqFt ?? this.plotAreaSqFt,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      qualityTier: qualityTier ?? this.qualityTier,
      estimate: estimate ?? this.estimate,
    );
  }

  double get plotAreaSqYards => plotAreaSqFt / 9.0;
  int get floors => numberOfFloors;
}

class BOQNotifier extends StateNotifier<BOQState> {
  final BOQEstimatorService _service;

  BOQNotifier({BOQEstimatorService service = const BOQEstimatorService()})
      : _service = service,
        super(
          BOQState(
            plotAreaSqFt: 1200.0,
            numberOfFloors: 2,
            qualityTier: ConstructionQualityTier.standard,
            estimate: service.calculateEstimate(
              plotAreaSqFt: 1200.0,
              numberOfFloors: 2,
              qualityTier: ConstructionQualityTier.standard,
            ),
          ),
        );

  void updatePlotArea(double area) {
    if (area <= 0) return;
    final newEstimate = _service.calculateEstimate(
      plotAreaSqFt: area,
      numberOfFloors: state.numberOfFloors,
      qualityTier: state.qualityTier,
    );
    state = state.copyWith(plotAreaSqFt: area, estimate: newEstimate);
  }

  void updateFloors(int floors) {
    if (floors < 1 || floors > 10) return;
    final newEstimate = _service.calculateEstimate(
      plotAreaSqFt: state.plotAreaSqFt,
      numberOfFloors: floors,
      qualityTier: state.qualityTier,
    );
    state = state.copyWith(numberOfFloors: floors, estimate: newEstimate);
  }

  void updateTier(ConstructionQualityTier tier) {
    final newEstimate = _service.calculateEstimate(
      plotAreaSqFt: state.plotAreaSqFt,
      numberOfFloors: state.numberOfFloors,
      qualityTier: tier,
    );
    state = state.copyWith(qualityTier: tier, estimate: newEstimate);
  }

  int addAllToCart(WidgetRef ref) {
    int count = 0;
    for (final item in state.estimate.materials) {
      final product = ProductModel(
        id: 'boq-item-${item.id}',
        vendorId: 'vendor-delhi-central',
        vendorName: 'Delhi-NCR Core Structural Depot',
        name: item.name,
        description: '${item.specificationNote} | Brand: ${item.recommendedBrand}',
        categoryId: 'cat-materials',
        categoryName: item.category,
        brand: item.recommendedBrand,
        images: const ['https://images.unsplash.com/photo-1504307651254-35680f356dfd'],
        price: item.unitPriceInr,
        unit: item.unit,
        minimumOrderQuantity: 1,
        stock: 50000,
        createdAt: DateTime.now(),
      );

      final quantity = item.estimatedQuantity.round().clamp(1, 10000);
      ref.read(cartProvider.notifier).addItem(product, quantity: quantity);
      count++;
    }
    return count;
  }
}

final boqProvider = StateNotifierProvider<BOQNotifier, BOQState>((ref) {
  return BOQNotifier();
});
