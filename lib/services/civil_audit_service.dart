import '../models/civil_audit_model.dart';

class CivilAuditService {
  const CivilAuditService();

  CivilAuditReport getAuditReportForMilestone(String milestoneId, int stageNumber, String stageName) {
    List<CivilAuditItem> items;

    if (stageNumber <= 3) {
      items = const [
        CivilAuditItem(
          id: 'test-01',
          testName: 'Concrete Cube Compressive Strength (28-day)',
          standardCode: 'IS 516:1959',
          measuredValue: '28.2 N/mm²',
          toleranceCriteria: '≥ 25.0 N/mm² for M25 Grade',
          status: AuditItemStatus.passed,
          notes: 'Standard NABL accredited lab cube crushing report attached.',
        ),
        CivilAuditItem(
          id: 'test-02',
          testName: 'TMT Steel Rebar Spacing & Concrete Cover',
          standardCode: 'IS 456:2000',
          measuredValue: 'Clear cover 25mm verified',
          toleranceCriteria: 'Cover block 25mm (±2mm)',
          status: AuditItemStatus.passed,
          notes: 'High-density PVC cover blocks utilized across all columns.',
        ),
        CivilAuditItem(
          id: 'test-03',
          testName: 'Anti-Termite Soil Emulsion Chemical Barrier',
          standardCode: 'IS 6313 (Part 2)',
          measuredValue: 'Chlorpyrifos 20% EC applied',
          toleranceCriteria: '5.0 L / linear meter of trench',
          status: AuditItemStatus.passed,
          notes: '10-Year chemical warranty certificate issued.',
        ),
      ];
    } else if (stageNumber <= 6) {
      items = const [
        CivilAuditItem(
          id: 'test-04',
          testName: 'Hydrostatic Water Pipe Pressure Test',
          standardCode: 'IS 12235 (Part 8)',
          measuredValue: '6.5 Bar maintained for 24h',
          toleranceCriteria: '≥ 6.0 Bar with zero drop in pressure gauge',
          status: AuditItemStatus.passed,
          notes: 'All bathroom concealed lines hold pressure under test gauge.',
        ),
        CivilAuditItem(
          id: 'test-05',
          testName: 'Electrical Earth Pit Resistance Verification',
          standardCode: 'IS 3043:2018',
          measuredValue: '2.8 Ohms measured',
          toleranceCriteria: '< 5.0 Ohms for residential earthing',
          status: AuditItemStatus.passed,
          notes: 'Dual chemical earthing electrodes bonded with copper tape.',
        ),
        CivilAuditItem(
          id: 'test-06',
          testName: 'Brick Masonry Plumb-line & Joint Thickness',
          standardCode: 'IS 2212:1991',
          measuredValue: '10mm uniform mortar joint',
          toleranceCriteria: 'Mortar bed 10mm - 12mm; Plumb vertical < 3mm/m',
          status: AuditItemStatus.passed,
          notes: 'Laser transit level test passed with zero lateral tilt.',
        ),
      ];
    } else {
      items = const [
        CivilAuditItem(
          id: 'test-07',
          testName: 'Wall Plaster Moisture Content Measurement',
          standardCode: 'IS 14164:1994',
          measuredValue: '9.4% Relative Moisture',
          toleranceCriteria: '< 12% before primer & putty application',
          status: AuditItemStatus.passed,
          notes: 'Digital pinless moisture meter certified substrate readiness.',
        ),
        CivilAuditItem(
          id: 'test-08',
          testName: 'Vitrified Flooring Hollow Sound Tapping Inspection',
          standardCode: 'IS 14455:1997',
          measuredValue: '100% full mortar coverage',
          toleranceCriteria: '0% hollow voids under acoustic rod tap test',
          status: AuditItemStatus.passed,
          notes: 'Complete adhesive polymer bond under 800x1600mm slabs.',
        ),
      ];
    }

    return CivilAuditReport(
      reportId: 'AUD-$milestoneId-${stageNumber.toString().padLeft(2, "0")}',
      milestoneId: milestoneId,
      stageName: stageName,
      auditorName: 'Er. Sandeep Bhasin (M.Tech Structural, IIT Delhi)',
      auditorLicense: 'CPWD / MCD Reg. Civil Auditor #CA-9042',
      auditedAt: DateTime.now().subtract(const Duration(hours: 18)),
      items: items,
    );
  }
}
