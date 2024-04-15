import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/app.dart';
import 'package:flutter_firebase_login/home/home.dart';
import 'package:flutter_firebase_login/residuo/residuo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text('Home', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.name ?? ''),
              accountEmail: Text(user.email ?? ''),
              currentAccountPicture: Avatar(
                photo: user.photo,
              ),
            ),
            ListTile(
              title: const Text('Gestão de residuos'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ResiduosPage>(
                    builder: (_) => BlocProvider.value(
                      value: ResiduosBloc(
                        user: user
                      ), child: ResiduosPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Residuos"),
          ],
        ),
      ),
    );
  }
}
