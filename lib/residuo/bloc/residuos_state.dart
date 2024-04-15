part of 'residuos_bloc.dart';

enum ResiduosStatus {
  initial,
  loading,
  loaded,
  changed,
  error
}

final class ResiduosState extends Equatable {
  const ResiduosState._({
    required this.status,
    this.residuos,
    this.error
  });

  const ResiduosState.initial () : this._(status: ResiduosStatus.initial);
  const ResiduosState.loading () : this._(status: ResiduosStatus.loading);
  const ResiduosState.loaded ( List<Residuos>? residuos ) : this._(status: ResiduosStatus.loaded, residuos: residuos);
  const ResiduosState.changed ( List<Residuos>? residuos ) : this._(status: ResiduosStatus.changed, residuos: residuos);
  const ResiduosState.error ({ required Object error }) : this._(status: ResiduosStatus.error, error: error);

  final ResiduosStatus status;
  final List<Residuos>? residuos;
  final Object? error;
  
  List<Object> get props => [status];
}