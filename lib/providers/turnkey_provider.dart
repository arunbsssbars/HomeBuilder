import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/turnkey_model.dart';

class TurnkeyState {
  final ProjectModel activeProject;
  final List<TurnkeyPackageModel> packages;

  const TurnkeyState({
    required this.activeProject,
    required this.packages,
  });

  TurnkeyState copyWith({
    ProjectModel? activeProject,
    List<TurnkeyPackageModel>? packages,
  }) {
    return TurnkeyState(
      activeProject: activeProject ?? this.activeProject,
      packages: packages ?? this.packages,
    );
  }
}

class TurnkeyNotifier extends StateNotifier<TurnkeyState> {
  TurnkeyNotifier() : super(_initialState);

  static final TurnkeyState _initialState = TurnkeyState(
    activeProject: ProjectModel(
      id: 'PROJ-NCR-401',
      customerId: 'CUST-001',
      customerName: 'Rahul Sharma',
      projectName: 'DLF Phase 5 Luxury Villa',
      location: 'Plot #42, DLF Phase 5, Gurugram',
      totalContractAmount: 5200000,
      totalPaidAmount: 1560000,
      currentProgressPercentage: 30.0,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      expectedCompletionDate: DateTime.now().add(const Duration(days: 240)),
      milestones: [
        MilestoneModel(
          id: 'MLST-01',
          stageNumber: 1,
          name: 'Soil Test & Municipal Sanction (MCD/GMDA)',
          description: 'Plate load bearing tests, DTCP approved architectural drawings and excavation sanction.',
          escrowAmount: 520000,
          status: MilestoneStatus.completed,
          dueDate: '2026-08-15',
          completedAt: DateTime.now().subtract(const Duration(days: 45)),
          inspectionChecklist: [
            'Borehole soil bearing capacity certified (> 180 kN/m2)',
            'GMDA sanction layout signed off by Registered Architect',
            'Water table depth monitored at 8.2m below ground',
          ],
          auditorSignoff: 'Er. Sandeep Mittal (Chief Civil Auditor)',
        ),
        MilestoneModel(
          id: 'MLST-02',
          stageNumber: 2,
          name: 'Excavation & Plinth Beam Casting',
          description: 'Raft foundation, Fe550D rebar cage, M-25 RMC pour and IS 6313 chemical termite barrier.',
          escrowAmount: 1040000,
          status: MilestoneStatus.completed,
          dueDate: '2026-09-30',
          completedAt: DateTime.now().subtract(const Duration(days: 10)),
          inspectionChecklist: [
            'Chlorpyrifos chemical termite barrier injected at 7.5 L/sq.m',
            'Cover blocks 50mm verified on all footing cages',
            '7-day compressive concrete cube strength > 19.5 MPa',
          ],
          auditorSignoff: 'Er. Sandeep Mittal (Chief Civil Auditor)',
        ),
        const MilestoneModel(
          id: 'MLST-03',
          stageNumber: 3,
          name: 'Superstructure RCC Columns & Slab 1',
          description: 'Earthquake Zone IV ductile detailing, shear walls, M-25 design mix slab casting.',
          escrowAmount: 1560000,
          status: MilestoneStatus.inProgress,
          dueDate: '2026-11-15',
          inspectionChecklist: [
            '135-degree seismic hooks on all column ties (IS 13920)',
            'Prop spacing verified at max 1.2m grid under formwork',
            'Curing sensor nodes installed for 14-day wet ponding',
          ],
        ),
        const MilestoneModel(
          id: 'MLST-04',
          stageNumber: 4,
          name: 'Class-1 Brickwork, MEP & Waterproofing',
          description: 'AAC block masonry, Astral CPVC plumbing loops, FRLS conduit wiring, terrace APP membrane.',
          escrowAmount: 1040000,
          status: MilestoneStatus.pending,
          dueDate: '2027-01-30',
        ),
        const MilestoneModel(
          id: 'MLST-05',
          stageNumber: 5,
          name: 'Luxury Finishes & Master Handover Audit',
          description: 'Italian marble, VRV AC commissioning, solar net meter, CPCB IV+ DG backup, final OC.',
          escrowAmount: 1040000,
          status: MilestoneStatus.pending,
          dueDate: '2027-04-15',
        ),
      ],
    ),
    packages: const [],
  );

  void releaseMilestoneEscrow(String milestoneId) {
    final updatedMilestones = state.activeProject.milestones.map((m) {
      if (m.id == milestoneId) {
        return m.copyWith(
          status: MilestoneStatus.completed,
          completedAt: DateTime.now(),
        );
      }
      return m;
    }).toList();

    state = state.copyWith(
      activeProject: ProjectModel(
        id: state.activeProject.id,
        customerId: state.activeProject.customerId,
        customerName: state.activeProject.customerName,
        projectName: state.activeProject.projectName,
        location: state.activeProject.location,
        totalContractAmount: state.activeProject.totalContractAmount,
        totalPaidAmount: state.activeProject.totalPaidAmount + 1040000,
        currentProgressPercentage: 60.0,
        startDate: state.activeProject.startDate,
        expectedCompletionDate: state.activeProject.expectedCompletionDate,
        milestones: updatedMilestones,
      ),
    );
  }

  void approveMilestone(String milestoneId) {
    releaseMilestoneEscrow(milestoneId);
  }
}

final turnkeyProvider = StateNotifierProvider<TurnkeyNotifier, TurnkeyState>((ref) {
  return TurnkeyNotifier();
});
