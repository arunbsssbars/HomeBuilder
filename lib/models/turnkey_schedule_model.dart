import 'package:flutter/foundation.dart';

enum ConstructionMilestoneType {
  sitePreparationAndExcavation,
  plinthAndFoundation,
  rccSuperstructure,
  brickworkAndMasonry,
  mepConcealedPlumbingElectrical,
  internalPlasterAndWaterproofing,
  flooringAndTiling,
  doorsWindowsAndFalseCeiling,
  finishingAndPainting,
  finalHandoverAndInspection,
}

@immutable
class MilestoneTask {
  final String id;
  final String name;
  final ConstructionMilestoneType type;
  final int durationDays;
  final List<String> dependsOnIds;
  final double paymentPercentage;
  final bool isAffectedByGrapBan;
  final int earliestStartDay;
  final int earliestFinishDay;
  final int latestStartDay;
  final int latestFinishDay;
  final bool isCriticalPath;

  const MilestoneTask({
    required this.id,
    required this.name,
    required this.type,
    required this.durationDays,
    this.dependsOnIds = const [],
    required this.paymentPercentage,
    this.isAffectedByGrapBan = false,
    this.earliestStartDay = 0,
    this.earliestFinishDay = 0,
    this.latestStartDay = 0,
    this.latestFinishDay = 0,
    this.isCriticalPath = false,
  });

  MilestoneTask copyWith({
    String? id,
    String? name,
    ConstructionMilestoneType? type,
    int? durationDays,
    List<String>? dependsOnIds,
    double? paymentPercentage,
    bool? isAffectedByGrapBan,
    int? earliestStartDay,
    int? earliestFinishDay,
    int? latestStartDay,
    int? latestFinishDay,
    bool? isCriticalPath,
  }) {
    return MilestoneTask(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      durationDays: durationDays ?? this.durationDays,
      dependsOnIds: dependsOnIds ?? this.dependsOnIds,
      paymentPercentage: paymentPercentage ?? this.paymentPercentage,
      isAffectedByGrapBan: isAffectedByGrapBan ?? this.isAffectedByGrapBan,
      earliestStartDay: earliestStartDay ?? this.earliestStartDay,
      earliestFinishDay: earliestFinishDay ?? this.earliestFinishDay,
      latestStartDay: latestStartDay ?? this.latestStartDay,
      latestFinishDay: latestFinishDay ?? this.latestFinishDay,
      isCriticalPath: isCriticalPath ?? this.isCriticalPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'durationDays': durationDays,
        'dependsOnIds': dependsOnIds,
        'paymentPercentage': paymentPercentage,
        'isAffectedByGrapBan': isAffectedByGrapBan,
        'earliestStartDay': earliestStartDay,
        'earliestFinishDay': earliestFinishDay,
        'latestStartDay': latestStartDay,
        'latestFinishDay': latestFinishDay,
        'isCriticalPath': isCriticalPath,
      };
}

@immutable
class ProjectSchedulePlan {
  final double builtUpAreaSqFt;
  final int floorsCount;
  final int baseDurationDays;
  final int grapBufferDays;
  final int totalEstimatedCalendarDays;
  final List<MilestoneTask> milestones;
  final List<String> criticalPathTaskIds;

  const ProjectSchedulePlan({
    required this.builtUpAreaSqFt,
    required this.floorsCount,
    required this.baseDurationDays,
    required this.grapBufferDays,
    required this.totalEstimatedCalendarDays,
    required this.milestones,
    required this.criticalPathTaskIds,
  });

  double get totalMilestonePaymentPercent =>
      milestones.fold(0.0, (acc, m) => acc + m.paymentPercentage);

  Map<String, dynamic> toJson() => {
        'builtUpAreaSqFt': builtUpAreaSqFt,
        'floorsCount': floorsCount,
        'baseDurationDays': baseDurationDays,
        'grapBufferDays': grapBufferDays,
        'totalEstimatedCalendarDays': totalEstimatedCalendarDays,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'criticalPathTaskIds': criticalPathTaskIds,
      };
}
