import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

part 'residuo_event.dart';
part 'residuo_state.dart';

class ResiduoBloc extends Bloc<ResiduoEvent, StateResiduo>{
  ResiduoBloc ({
    required User user,
    required Residuos residuos,
    ResiduoRepository? residuoRepository
  }) : user = user, _residuoRepository = residuoRepository ?? ResiduoRepository(), super(StateResiduo.initial(residuos: residuos)) {
    on <AddResiduo> ((event, emit) async {
      emit(StateResiduo.adding(residuos: event.residuos));
      emit(await _residuoRepository.add(userId: user.id, residuos: event.residuos).then((residuos) {
        return StateResiduo.added(residuos: residuos);
      },
      onError: (error, stackTrace) {
        print(error);
        return StateResiduo.error(residuos: residuos, error: error);
      }
      ));
    });
    on <UpdateResiduo> ((event, emit) async {
      emit(StateResiduo.updating(residuos: event.residuos));
      emit(await _residuoRepository.update(userId: user.id, residuos: event.residuos).then((result) {
        return StateResiduo.updated(residuos: event.residuos);
      },
      onError: (error, stackTrace) {
        print(error);
        return StateResiduo.error(residuos: residuos, error: error);
      }
      ));
    });
    on <DeleteResiduo> ((event, emit) async {
      emit(StateResiduo.deleting(residuos: event.residuos));
      emit(await _residuoRepository.delete(userId: user.id, residuos: event.residuos).then((value) {
        return StateResiduo.deleted(residuos: event.residuos);
      },
      onError: (error, stackTrace) {
        print(error);
        return StateResiduo.error(residuos: residuos, error: error);
      }
      ));
    });
  }

  final User user;
  final ResiduoRepository _residuoRepository;
}