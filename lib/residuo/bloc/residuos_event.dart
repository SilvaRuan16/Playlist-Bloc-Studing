part of 'residuos_bloc.dart';

sealed class ResiduosEvent {
  const ResiduosEvent();
}

final class ListAllResiduos extends ResiduosEvent {
  const ListAllResiduos();
}