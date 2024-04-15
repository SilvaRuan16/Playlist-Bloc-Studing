import 'package:database_repository/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_firebase_login/residuo/bloc/residuos_bloc.dart';
import 'package:flutter_firebase_login/residuo/residuo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class ResiduosPage extends StatefulWidget {
  const ResiduosPage({super.key});

  @override
  State <StatefulWidget> createState() => _ResiduosPageState();
}

class _ResiduosPageState extends State<ResiduosPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ResiduosBloc>(context).add(ListAllResiduos());
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Lista de residuos', style: TextStyle(color: Colors.white),),
        actions: <Widget> [
          IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {
            Navigator.pop(context);
          },),
        ],
      ),
      body: BlocListener<ResiduosBloc, ResiduosState>(
        bloc: BlocProvider.of<ResiduosBloc>(context),
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          switch (state.status){
            case ResiduosStatus.error:
              messenger.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Erro inesperado! tente novamente mais tarde.',
                    style: TextStyle(color: Colors.red)
                  ),
                ),
              );
            default:
          }
        },
        child: BlocBuilder<ResiduosBloc, ResiduosState>(
          bloc: BlocProvider.of<ResiduosBloc>(context),
          builder: (context, state) {
            switch (state.status) {
              case ResiduosStatus.loading :
                return const LinearProgressIndicator();
              case ResiduosStatus.loaded :
              if(state.residuos!.isEmpty){
                return const Center(
                  child: const Text('A lista de resíduos está vazia.'),
                );
              }
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.residuos!.length,
                itemBuilder: (context, index) {
                  String date = '';
                  try{
                    /*
                      o texto do controlador vai receber a formatação BR por ano, mês, dia -> vai ser formatado a data do residuo
                    */
                    date = DateFormat.yMMMMd('pt_BR').format(state.residuos![index].date!);
                  }catch(exception){}
                  return ListTile(
                    leading: CircleAvatar(
                      child: Center(
                        child: Text(state.residuos![index].name[0]),
                      ),
                    ),
                    title: Text(state.residuos![index].name),
                    subtitle: Text(date),
                    trailing: Text((state.residuos![index].size ?? '').toString()),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<ResiduosPage>(
                        builder: (_) => BlocProvider.value(
                          value: ResiduoBloc(
                            user: BlocProvider.of<ResiduosBloc>(context).user,
                            residuos: state.residuos![index],
                          ),
                          child: ResiduoForm(),
                        ),
                      ),
                    ),
                  );
                },
              );
              default :
                return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<ResiduosPage>(
              builder: (_) => BlocProvider.value(
                value: ResiduoBloc(
                  user: BlocProvider.of<ResiduosBloc>(context).user, residuos: Residuos.empty
                ),
                child: ResiduoForm(),
              ),
            ),
          );
        }
      ),
    );
  }
}