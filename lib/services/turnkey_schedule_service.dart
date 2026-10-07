import 'dart:math';
import '../models/turnkey_schedule_model.dart';

class TurnkeyScheduleService {
  const TurnkeyScheduleService();

  ProjectSchedulePlan calculateSchedule({
    required double builtUpAreaSqFt,
    required int floorsCount,
    bool includeDelhiNcrGrapBuffer = true,
    int customGrapDays = 35,
  }) {
    final floors = max(1, floorsCount);
    final areaScale = max(0.8, min(2.5, builtUpAreaSqFt / 2000.0));

    // Base milestone durations scaled by floors and area
    final excavationDays = max(10, (14 * sqrt(areaScale)).round());
    final plinthDays = max(18, (22 * sqrt(areaScale)).round());
    final rccDays = max(20, (22 * floors * sqrt(areaScale)).round());
    final masonryDays = max(14, (14 * floors * sqrt(areaScale)).round());
    final mepDays = max(14, (12 * floors + 8).round());
    final plasterWaterproofingDays = max(15, (12 * floors + 10).round());
    final flooringDays = max(15, (12 * floors + 8).round());
    final fenestrationCeilingDays = max(12, (10 * floors + 6).round());
    final finishingPaintingDays = max(18, (15 * floors + 10).round());
    const handoverSnaggingDays = 12;

    final rawMilestones = <MilestoneTask>[
      MilestoneTask(
        id: 'T1',
        name: 'Site Prep, Soil Anti-Termite & Excavation',
        type: ConstructionMilestoneType.sitePreparationAndExcavation,
        durationDays: excavationDays,
        dependsOnIds: const [],
        paymentPercentage: 10.0,
        isAffectedByGrapBan: true,
      ),
      MilestoneTask(
        id: 'T2',
        name: 'Sub-structure Footings & Plinth Beam',
        type: ConstructionMilestoneType.plinthAndFoundation,
        durationDays: plinthDays,
        dependsOnIds: const ['T1'],
        paymentPercentage: 15.0,
        isAffectedByGrapBan: true,
      ),
      MilestoneTask(
        id: 'T3',
        name: 'RCC Superstructure Columns, Beams & Slabs ($floors Flr)',
        type: ConstructionMilestoneType.rccSuperstructure,
        durationDays: rccDays,
        dependsOnIds: const ['T2'],
        paymentPercentage: 20.0,
        isAffectedByGrapBan: true,
      ),
      MilestoneTask(
        id: 'T4',
        name: 'AAC Block / Red Brick Masonry Walls',
        type: ConstructionMilestoneType.brickworkAndMasonry,
        durationDays: masonryDays,
        dependsOnIds: const ['T3'],
        paymentPercentage: 15.0,
        isAffectedByGrapBan: true,
      ),
      MilestoneTask(
        id: 'T5',
        name: 'Concealed MEP (Piping, Conduits & Plumbing)',
        type: ConstructionMilestoneType.mepConcealedPlumbingElectrical,
        durationDays: mepDays,
        dependsOnIds: const ['T4'],
        paymentPercentage: 10.0,
        isAffectedByGrapBan: false,
      ),
      MilestoneTask(
        id: 'T6',
        name: 'Waterproofing, Curing & Internal/External Plaster',
        type: ConstructionMilestoneType.internalPlasterAndWaterproofing,
        durationDays: plasterWaterproofingDays,
        dependsOnIds: const ['T5'],
        paymentPercentage: 10.0,
        isAffectedByGrapBan: true,
      ),
      MilestoneTask(
        id: 'T7',
        name: 'Tile Flooring, Granite Countertops & Bathroom Wall Vitrified',
        type: ConstructionMilestoneType.flooringAndTiling,
        durationDays: flooringDays,
        dependsOnIds: const ['T6'],
        paymentPercentage: 10.0,
        isAffectedByGrapBan: false,
      ),
      MilestoneTask(
        id: 'T8',
        name: 'Doors, UPVC Windows & False Ceiling Framing',
        type: ConstructionMilestoneType.doorsWindowsAndFalseCeiling,
        durationDays: fenestrationCeilingDays,
        dependsOnIds: const ['T7'],
        paymentPercentage: 5.0,
        isAffectedByGrapBan: false,
      ),
      MilestoneTask(
        id: 'T9',
        name: 'Interior/Exterior Painting, Electrical & Sanitary Fixtures',
        type: ConstructionMilestoneType.finishingAndPainting,
        durationDays: finishingPaintingDays,
        dependsOnIds: const ['T8'],
        paymentPercentage: 5.0,
        isAffectedByGrapBan: false,
      ),
      const MilestoneTask(
        id: 'T10',
        name: 'Snagging Audit, Deep Cleaning & Turnkey Handover',
        type: ConstructionMilestoneType.finalHandoverAndInspection,
        durationDays: handoverSnaggingDays,
        dependsOnIds: ['T9'],
        paymentPercentage: 0.0, // Retained final milestone / occupancy
        isAffectedByGrapBan: false,
      ),
    ];

    // Compute Critical Path Method (CPM) Forward Pass
    final taskMap = <String, MilestoneTask>{};
    for (final task in rawMilestones) {
      taskMap[task.id] = task;
    }

    final forwardTasks = <MilestoneTask>[];
    for (final task in rawMilestones) {
      int es = 0;
      for (final depId in task.dependsOnIds) {
        final depTask = taskMap[depId];
        if (depTask != null && depTask.earliestFinishDay > es) {
          es = depTask.earliestFinishDay;
        }
      }
      final ef = es + task.durationDays;
      final updated = task.copyWith(
        earliestStartDay: es,
        earliestFinishDay: ef,
      );
      taskMap[task.id] = updated;
      forwardTasks.add(updated);
    }

    final baseDurationDays = forwardTasks.fold<int>(
      0,
      (maxVal, t) => t.earliestFinishDay > maxVal ? t.earliestFinishDay : maxVal,
    );

    // Compute CPM Backward Pass
    for (int i = forwardTasks.length - 1; i >= 0; i--) {
      final task = forwardTasks[i];
      // Successors of this task
      final successors = forwardTasks.where((t) => t.dependsOnIds.contains(task.id)).toList();
      int lf = baseDurationDays;
      if (successors.isNotEmpty) {
        lf = successors.map((s) => s.latestStartDay).reduce(min);
      }
      final ls = lf - task.durationDays;
      final isCritical = (ls == task.earliestStartDay);

      final backwardTask = task.copyWith(
        latestStartDay: ls,
        latestFinishDay: lf,
        isCriticalPath: isCritical,
      );
      taskMap[task.id] = backwardTask;
      forwardTasks[i] = backwardTask;
    }

    final criticalPathIds = forwardTasks
        .where((t) => t.isCriticalPath)
        .map((t) => t.id)
        .toList();

    final grapBuffer = includeDelhiNcrGrapBuffer ? customGrapDays : 0;
    final totalCalendarDays = baseDurationDays + grapBuffer;

    return ProjectSchedulePlan(
      builtUpAreaSqFt: builtUpAreaSqFt,
      floorsCount: floors,
      baseDurationDays: baseDurationDays,
      grapBufferDays: grapBuffer,
      totalEstimatedCalendarDays: totalCalendarDays,
      milestones: forwardTasks,
      criticalPathTaskIds: criticalPathIds,
    );
  }
}
