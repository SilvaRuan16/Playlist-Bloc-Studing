part of 'residuo_bloc.dart';

enum StatusResiduo {
  initial,
  adding,
  added,
  updating,
  updated,
  deleting,
  deleted,
  error
}

final class StateResiduo extends Equatable {
  const StateResiduo._({
    required this.statusResiduo,
    required this.residuos,
    this.error
  });

  const StateResiduo.initial({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.initial, residuos: residuos);
  const StateResiduo.adding({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.adding, residuos: residuos);
  const StateResiduo.added({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.added, residuos: residuos);
  const StateResiduo.updating({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.updating, residuos: residuos);
  const StateResiduo.updated({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.updated, residuos: residuos);
  const StateResiduo.deleting({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.deleting, residuos: residuos);
  const StateResiduo.deleted({required Residuos residuos}) : this._(statusResiduo: StatusResiduo.deleted, residuos: residuos);
  const StateResiduo.error({required Residuos residuos, required Object error}) : this._(statusResiduo: StatusResiduo.error, residuos: residuos, error: error);

  final StatusResiduo statusResiduo;
  final Residuos residuos;
  final Object? error;

  bool get isBusy {
    if(this.statusResiduo case StatusResiduo.adding || StateResiduo.updating || StateResiduo.deleting) return true;
    return false;
  }

  bool get isValid => this.statusResiduo != StateResiduo.deleted;

  List <Object> get props => [statusResiduo];
}