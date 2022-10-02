import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica_1_audio/bloc/home_bloc.dart';
import 'package:practica_1_audio/datos_cancion.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String textoH = 'presione para esuchar';
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeInitial) {
          textoH = 'presione para escuchar';
        }
        if (state is HomeRecording) {
          textoH = 'escuchando';
        }
        if (state is RecordingSucces) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: showingSong(
                        context, state.recordContent, state.favFlag),
                  )));
        }

        if (state is RecordingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error al grabar, ${state.error}')),
          );
        }
        if (state is favoritos) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: showingFavs(context, state.listaParaPantalla),
                  )));
        }
      },
      builder: (context, state) {
        if (state is HomeInitial) {
          return homie(context, false, textoH);
        } else if (state is HomeRecording) {
          return homie(context, true, textoH);
        } else if (state is RecordingSucces) {
          return homie(context, false, textoH);
        } else if (state is RecordingError) {
        } else if (state is favoritos) {
          return homie(context, false, textoH);
        }
        return homie(context, false, textoH);
      },
    );
  }
}

Widget presentacion(BuildContext context, DatosCancion cancion) {
  return Container(
    child: Column(
      children: [
        Image(
          image: NetworkImage(cancion.imagen),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
        ),
        Text(cancion.titulo)
      ],
    ),
  );
}

Widget showingFavs(BuildContext context, List lista) {
  return Scaffold(
    body: ListView.builder(
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        var elemento = lista[index];
        return presentacion(context, elemento);
      },
    ),
  );
}

Widget showingSong(BuildContext context, DatosCancion datos_cancion, favFlag) {
  return Scaffold(
    appBar: AppBar(
      title: Text('there you go'),
    ),
    body: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(datos_cancion.imagen),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                datos_cancion.titulo),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                datos_cancion.album),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Text(style: TextStyle(fontSize: 12), datos_cancion.artista),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(style: TextStyle(fontSize: 12), datos_cancion.fecha),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              iconSize: 40,
              icon: FaIcon(favFlag
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart),
              onPressed: () {
                print('fav pressed');
                BlocProvider.of<HomeBloc>(context).add(clickOnSuccesEvent(
                    funcion_boton: 'fav',
                    datos_cancion: datos_cancion,
                    favFlag: favFlag));
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              iconSize: 40,
              icon: FaIcon(FontAwesomeIcons.spotify),
              onPressed: () {
                print('spotify pressed');
                BlocProvider.of<HomeBloc>(context).add(clickOnSuccesEvent(
                    funcion_boton: 'spotify',
                    datos_cancion: datos_cancion,
                    favFlag: favFlag));
              },
            ),
            IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              iconSize: 40,
              icon: FaIcon(FontAwesomeIcons.deezer),
              onPressed: () {
                print('deezer pressed');
                BlocProvider.of<HomeBloc>(context).add(clickOnSuccesEvent(
                    funcion_boton: 'deezer',
                    datos_cancion: datos_cancion,
                    favFlag: favFlag));
              },
            ),
            IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              iconSize: 40,
              icon: FaIcon(FontAwesomeIcons.apple),
              onPressed: () {
                print('apple pressed');
                BlocProvider.of<HomeBloc>(context).add(clickOnSuccesEvent(
                    funcion_boton: 'apple',
                    datos_cancion: datos_cancion,
                    favFlag: favFlag));
              },
            ),
          ])
        ],
      ),
    ),
  );
}

Widget homie(BuildContext context, animate, String texto) {
  final _animate = animate;
  return Scaffold(
    body: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(style: TextStyle(fontSize: 25), texto)],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: AvatarGlow(
                glowColor: Colors.red,
                endRadius: 170,
                animate: _animate,
                child: Material(
                  // Replace this child with your own
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: IconButton(
                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                      iconSize: 60,
                      icon: FaIcon(FontAwesomeIcons.music),
                      onPressed: () {
                        print('pressed');
                        BlocProvider.of<HomeBloc>(context)
                            .add(StartRecordEvent());
                      },
                    ),
                    radius: 80,
                  ),
                ),
              ),
            ),
            Material(
              elevation: 8.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                    icon: FaIcon(FontAwesomeIcons.heart),
                    onPressed: () {
                      print('favoritos pressed');
                      BlocProvider.of<HomeBloc>(context)
                          .add(verFavoritosEvent());
                    }),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
