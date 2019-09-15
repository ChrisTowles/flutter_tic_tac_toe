import 'package:flutter/material.dart';
import 'package:tic_tac_toe/bloc/bloc_provider.dart';
import 'package:tic_tac_toe/bloc/game_bloc.dart';
import 'package:tic_tac_toe/screens/game_board/game_board.dart';

class GameProcessPage extends StatefulWidget {
  GameProcessPage({Key key}) : super(key: key);

  @override
  _GameProcessPageState createState() => new _GameProcessPageState();
}

class _GameProcessPageState extends State<GameProcessPage> {
  GameBloc _gameBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc = TTTBlocProvider.of<GameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<String>(
              initialData: '',
              stream: _gameBloc.multiNetworkMessage,
              builder: (context, messageSnapshot) {
                return Text(
                  messageSnapshot.data,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(
              height: 40.0,
            ),
            StreamBuilder<bool>(
              initialData: false,
              stream: _gameBloc.multiNetworkStarted,
              builder: (context, startedSnapshot) {
                return (startedSnapshot.data)
                    ? RaisedButton(
                        child: Text('GO TO GAME'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (index) => GameBoard()));
                        },
                      )
                    : Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
