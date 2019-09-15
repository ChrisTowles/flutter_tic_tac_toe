import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/bloc/authentication_bloc/bloc.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
   //  final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text("Page 1"),
                    onTap: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        // close the app drawer
                        Navigator.of(context).pop();
                        //homeBloc.dispatch(HomeEvent.page1Active);
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text("Home"),
                    onTap: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        // close the app drawer
                        Navigator.of(context).pop();
                        //homeBloc.dispatch(HomeEvent.homePageActive);
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        // close the app drawer
                        Navigator.of(context).pop();
                        authenticationBloc.dispatch(          LoggedOut());
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
