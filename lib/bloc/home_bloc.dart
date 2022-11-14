import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:practica_1_audio/datos_cancion.dart';
import 'package:record/record.dart';
import 'package:practica_1_audio/repositorio_audio.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<StartRecordEvent>(_recordSong);
    on<verFavoritosEvent>(_showFav);
    on<clickOnSuccesEvent>(_clickFunction);
  }
}

List lista = [];

FutureOr<void> _recordSong(StartRecordEvent event, emit) async {
  int record_duration = 6;
  final Record record = Record();
  final repo = repositorio_audio();
  //get permission
  bool permission = await record.hasPermission();
  if (!permission) {
    emit(RecordingError(error: 'no hay permiso de microfono'));
  }
  emit(HomeRecording());
  await record.start();
  await Future.delayed(Duration(seconds: record_duration));
  final path = await record.stop();
  if (path == null) {
    emit(RecordingError(error: 'upsi'));
    return;
  }
  File song = File(path);
  String base64Song = base64Encode(song.readAsBytesSync());

  DatosCancion? datos_cancion = await repo.recognizeSong(base64Song);
  if (datos_cancion != null) {
    var fav = await FirebaseFirestore.instance
        .collection('favoritos')
        .where('titulo', isEqualTo: datos_cancion.titulo)
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    print(fav.size == 0);
    if (fav.size == 0) {
      emit(RecordingSucces(recordContent: datos_cancion, favFlag: false));
    } else {
      emit(RecordingSucces(recordContent: datos_cancion, favFlag: true));
    }
  } else {
    emit(RecordingError(error: 'upsi'));
  }
}

FutureOr<void> _clickFunction(clickOnSuccesEvent event, emit) async {
  switch (event.funcion_boton) {
    case 'fav':
      if (event.favFlag == false) {
        await FirebaseFirestore.instance.collection('favoritos').add({
          'titulo': event.datos_cancion.titulo,
          'artista': event.datos_cancion.artista,
          'album': event.datos_cancion.album,
          'appleLink': event.datos_cancion.appleLink,
          'spotifyLink': event.datos_cancion.spotifyLink,
          'imagen': event.datos_cancion.imagen,
          'fecha': event.datos_cancion.fecha,
          'user': FirebaseAuth.instance.currentUser?.uid
        });
        emit(reloadState());
        emit(
            RecordingSucces(recordContent: event.datos_cancion, favFlag: true));
      } else {
        var removedSong = await FirebaseFirestore.instance
            .collection('favoritos')
            .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('titulo', isEqualTo: event.datos_cancion.titulo)
            .get()
            .then((querySnapshot) => querySnapshot);

        for (var doc in removedSong.docs) {
          await doc.reference.delete();
        }
        emit(reloadState());
        emit(RecordingSucces(
            recordContent: event.datos_cancion, favFlag: false));
      }

      break;
    case 'spotify':
      break;
    case 'deezer':
      break;
    case 'apple':
      break;
  }
}

FutureOr<void> _showFav(verFavoritosEvent, emit) async {
  var favoriteSongs = await getFavorites();
  emit(favoritos(listaParaPantalla: favoriteSongs));
}

FutureOr<List<dynamic>> getFavorites() async {
  var favoriteSongs = await FirebaseFirestore.instance
      .collection("favoritos")
      .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get();

  var mySongs = favoriteSongs.docs
      .map((doc) => doc.data().cast<String, String>())
      .toList();
  print(mySongs);
  return mySongs;
}
