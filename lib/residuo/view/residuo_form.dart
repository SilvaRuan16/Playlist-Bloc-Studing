//import 'package:database_repository/database_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/residuo/bloc/residuo_bloc.dart';
import 'package:flutter_firebase_login/residuo/residuo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class ResiduoForm extends StatefulWidget {
  const ResiduoForm({super.key});

  @override
  State <StatefulWidget> createState() => _ResiduoFormState();
}

class _ResiduoFormState extends State<ResiduoForm> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {

    final _validator = GlobalKey<FormState>(); // create a validator form

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Formulário de Residuo', style: TextStyle(color: Colors.white),),
        actions: <Widget> [
          IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {
            Navigator.pop(context);
          },),
        ],
      ),
      body: BlocListener<ResiduoBloc, StateResiduo>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        listener: (context, state) {
          final mensager = ScaffoldMessenger.of(context);
          mensager.hideCurrentSnackBar();
          switch(state.statusResiduo) {
            case StatusResiduo.deleted :
              mensager.showSnackBar(
                SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error),
                          Text(
                            'Residuo excluido com sucesso',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).closed.then((reason) => Navigator.pop(context));

            case StatusResiduo.added || StatusResiduo.updated :
              mensager.showSnackBar(
                SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error),
                          Text(
                            'Residuo salvo com sucesso',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            
            case StatusResiduo.error :
              mensager.showSnackBar(
                SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error),
                          Text(
                            'Aconteceu um erro inesperado, favor tente novamente mais tarde',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            default:
            
          }
        },
        child: SingleChildScrollView(// adiciona uma barra de rolagem
          child: BlocBuilder<ResiduoBloc, StateResiduo>(
            bloc: BlocProvider.of<ResiduoBloc>(context),
            builder: (context, state) {
              return Column(
                children: [
                  (state.isBusy) ? LinearProgressIndicator() : SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 600
                        ),
                        child: Form(
                          key: _validator,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Gerenciamento adequado de Residuos sólidos,'
                                ' incluindo coleta, reciclagem, tratamento,'
                                ' e disposição final de maneira ambientalmente seguro.'
                              ),
                              /*
                                    Vai chamar a classe name input que possui a formatação do campo
                                    de texto, e nessa classe, irá chamar o validador com a chave global
                                    que irá modificar o estado do formulário
                              */
                              _NameInput(_validator),
                              _SizeInput(),
                              _SolutionInput(),
                              _DataInput(),
          
                            ].map((widget) => Padding(
                              padding: EdgeInsets.all(13),
                              child: widget,
                            ),
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<ResiduoBloc, StateResiduo>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: (state.isBusy && !state.isValid) ? null : (){
              if(_validator.currentState!.validate()){
                if(state.residuos.isEmpty){
                  BlocProvider.of<ResiduoBloc>(context).add(AddResiduo(state.residuos));
                } else {
                  BlocProvider.of<ResiduoBloc>(context).add(UpdateResiduo(state.residuos));
                }
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BlocBuilder<ResiduoBloc, StateResiduo>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        builder: (context, state) {
          final _dispacthDelete = () => BlocProvider.of<ResiduoBloc>(context).add(DeleteResiduo(state.residuos));
          return BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ButtonBar(
                    children: [
                      ElevatedButton.icon(
                        onPressed: (state.isBusy || !state.isValid || state.residuos.isEmpty) ? null : () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content: const Text('Tem certeza de que deseja excluir este residuo?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancelar'),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Excluir');
                              _dispacthDelete();
                            },
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Excluir'),
                  ),
                ],),
            ],),
          );
        },
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput(GlobalKey<FormState> validator) : this._validator = validator;

  final GlobalKey<FormState> _validator;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, StateResiduo>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state){
        return TextFormField(
          autofocus: true,
          enabled: !state.isBusy && state.isValid,
          initialValue: state.residuos.name,
          onChanged: (name) {
            state.residuos.name = name; // irá chamar o parametro que receberá os residuos e o parametro
            _validator.currentState!.validate();
          },
          validator: (name) => name!.isEmpty ? 'Nome obrigatório' : null,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Nome',
            hintText: 'Nome de residuo',
            helperText: 'Resíduo orgânico, plásticos, metais, '
                        'vidro, papel, entre outros.'
          ),
        );
      },
    );
  }
}

class _SizeInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, StateResiduo>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state){
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: (state.residuos.size ?? '').toString(),
          onChanged: (size) => state.residuos.size = int.parse(size), // irá chamar o parametro que receberá os residuos e o parametro
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Quantidade',
            hintText: 'Quantidade de residuo',
            helperText: 'Quantidade de residuos gerados, coletados e tratados'
          ),
        );
      },
    );
  }
}

class _SolutionInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, StateResiduo>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state){
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: state.residuos.solution,
          onChanged: (solution) => state.residuos.solution = solution, // irá chamar o parametro que receberá os residuos e o parametro
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Tratamento',
            hintText: 'tratamento para o residuo',
            helperText: 
              'Métodos de tratamentos utilizados, como reciclagem, '
              'compostagem, incineração, aterro sanitário'
          ),
        );
      },
    );
  }
}

class _DataInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return BlocBuilder<ResiduoBloc, StateResiduo>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state){
        try{
          /*
            o texto do controlador vai receber a formatação BR por ano, mês, dia -> vai ser formatado a data do residuo
          */
          _controller.text = DateFormat.yMMMEd('pt_BR').format(state.residuos.date!);
        }catch(exception){}
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          readOnly: true,
          controller: _controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.date_range),
            labelText: 'Calendário',
            hintText: 'Selecionar data',
            helperText: 'Data do cadastro do residuo'
          ),
          onTap: () async {
            final datenow = state.residuos.date ?? DateTime.now();
            state.residuos.date = await showDatePicker(
              context: context,
              locale: Locale('pt', 'BR'),
              initialDate: datenow,
              firstDate: DateTime(datenow.year - 5),
              lastDate: DateTime(datenow.year + 5),
            );
            try{
              /*
                o texto do controlador vai receber a formatação BR por ano, mês, dia -> vai ser formatado a data do residuo
              */
              _controller.text = DateFormat.yMMMMd('pt_BR').format(state.residuos.date!);
            }catch(exception){}
          },
        );
      },
    );
  }
}