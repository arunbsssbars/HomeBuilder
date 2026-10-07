import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';

class CatalogState {
  final List<ProductModel> products;
  final List<ServiceModel> services;

  const CatalogState({
    required this.products,
    required this.services,
  });
}

class CatalogNotifier extends StateNotifier<CatalogState> {
  CatalogNotifier() : super(_initialState);

  static final CatalogState _initialState = CatalogState(
    products: [
      ProductModel(
        id: 'PROD-001',
        vendorId: 'VEND-001',
        vendorName: 'UltraTech Building Solutions NCR',
        name: 'UltraTech Premium PPC Cement',
        description: 'IS 1489 Part 1 Fly-ash based Portland Pozzolana Cement for structural casting',
        categoryId: 'CAT-CEMENT',
        categoryName: 'Cement & Concrete',
        brand: 'UltraTech',
        images: const ['https://example.com/cement.png'],
        price: 385,
        unit: 'bag',
        stock: 5000,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ProductModel(
        id: 'PROD-002',
        vendorId: 'VEND-002',
        vendorName: 'Tata Steel Authorized NCR Distributor',
        name: 'Tata Tiscon 550D TMT Steel Rebar',
        description: 'IS 1786 High ductility seismic rebar for Delhi-NCR Zone IV structures',
        categoryId: 'CAT-STEEL',
        categoryName: 'Structural Steel',
        brand: 'Tata Tiscon',
        images: const ['https://example.com/steel.png'],
        price: 64500,
        unit: 'metric ton',
        stock: 250,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ProductModel(
        id: 'PROD-003',
        vendorId: 'VEND-003',
        vendorName: 'Jhajjar Kiln Co-operative NCR',
        name: 'Class-1 Red Clay Kiln Bricks',
        description: 'IS 1077 Heavy compressive strength (> 10.5 MPa) kiln fired wire-cut bricks',
        categoryId: 'CAT-BRICKS',
        categoryName: 'Bricks & Blocks',
        brand: 'NCR Kiln Class-1',
        images: const ['https://example.com/bricks.png'],
        price: 7800,
        unit: '1000 units',
        stock: 80000,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ],
    services: const [
      ServiceModel(
        id: 'SERV-001',
        name: 'Senior Structural Civil Engineer Consultation',
        category: 'consultation',
        description: 'On-site foundation inspection, IS 456 ductility compliance & soil test review',
        hourlyRate: 1500,
        vendorId: 'VEND-004',
        vendorName: 'NCR Civil Engineering Associates',
        rating: 4.9,
        completedJobs: 124,
      ),
      ServiceModel(
        id: 'SERV-002',
        name: 'Turnkey Villa Plumbing & Drainage Execution',
        category: 'plumbing',
        description: 'Astral CPVC/UPVC ring loop execution, pressure testing & sewer line connection',
        hourlyRate: 950,
        vendorId: 'VEND-005',
        vendorName: 'Apex MEP Contractors Gurugram',
        rating: 4.8,
        completedJobs: 78,
      ),
    ],
  );
}

final catalogProvider = StateNotifierProvider<CatalogNotifier, CatalogState>((ref) {
  return CatalogNotifier();
});
