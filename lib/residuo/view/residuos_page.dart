import 'package:database_repository/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/residuo/residuo.dart';
import 'package:flutter/material.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de residuos'),
        actions: <Widget> [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
          },),
        ],
      ),
      // body: ,
      // floatingActionButton: ,
    );
  }
}