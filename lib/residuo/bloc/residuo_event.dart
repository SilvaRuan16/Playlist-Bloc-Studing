part of 'residuo_bloc.dart';

sealed class ResiduoEvent {
  const ResiduoEvent();
}

final class AddResiduo extends ResiduoEvent {
  const AddResiduo( this.residuos );
  final Residuos residuos;
}

final class UpdateResiduo extends ResiduoEvent {
  const UpdateResiduo( this.residuos );
  final Residuos residuos;
}

final class DeleteResiduo extends ResiduoEvent {
  const DeleteResiduo( this.residuos );
  final Residuos residuos;
}