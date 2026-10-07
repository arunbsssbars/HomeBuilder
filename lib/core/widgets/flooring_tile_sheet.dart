import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/flooring_spec_model.dart';
import '../../services/flooring_tile_calculator_service.dart';

class FlooringTileSheet extends StatefulWidget {
  const FlooringTileSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => const FlooringTileSheet(),
    );
  }

  @override
  State<FlooringTileSheet> createState() => _FlooringTileSheetState();
}

class _FlooringTileSheetState extends State<FlooringTileSheet> {
  final _service = const FlooringTileCalculatorService();
  final double _carpetArea = 250.0; // Living / Dining room avg
  TileSize _tileSize = TileSize.size2x4Ft;
  TileLayoutPattern _pattern = TileLayoutPattern.standardGrid;

  @override
  Widget build(BuildContext context) {
    final result = _service.calculateFlooring(
      FlooringInput(
        roomName: 'Living & Dining Hall',
        carpetAreaSqFt: _carpetArea,
        tileSize: _tileSize,
        layoutPattern: _pattern,
        includeSkirting: true,
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.grid_view, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Flooring Tile & Adhesive Calculator', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Calculates box packing, perimeter skirting, Type-2 adhesive & epoxy grout.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              // Inputs
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tile Format:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButton<TileSize>(
                          value: _tileSize,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: TileSize.size2x2Ft, child: Text('2ft × 2ft (16 sq.ft/box)')),
                            DropdownMenuItem(value: TileSize.size2x4Ft, child: Text('2ft × 4ft (16 sq.ft/box)')),
                            DropdownMenuItem(value: TileSize.size4x6FtSlab, child: Text('4ft × 6ft Slab')),
                            DropdownMenuItem(value: TileSize.italianMarbleSlab, child: Text('Italian Marble')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _tileSize = v);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Layout Pattern:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButton<TileLayoutPattern>(
                          value: _pattern,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: TileLayoutPattern.standardGrid, child: Text('Standard Grid (10%)')),
                            DropdownMenuItem(value: TileLayoutPattern.diagonalDiamond, child: Text('Diamond (15%)')),
                            DropdownMenuItem(value: TileLayoutPattern.herringbonePattern, child: Text('Herringbone (18%)')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _pattern = v);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOutputCol('Procurement Area', '${result.grossProcurementAreaSqFt} sq.ft'),
                        _buildOutputCol('Boxes Needed', '${result.totalBoxesNeeded} boxes'),
                        _buildOutputCol('Wastage Added', '${result.wastagePercentage}%'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Adhesive & Grout', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('${result.adhesiveBags20Kg} Bags (20kg) Adhesive', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text('${result.epoxyGroutKg} kg Epoxy Grout', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Estimated Cost', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text(
                              CurrencyFormatter.format(result.estimatedMaterialCostInr),
                              style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Calculator'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputCol(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 3),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
