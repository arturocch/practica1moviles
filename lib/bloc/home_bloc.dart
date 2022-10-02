import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    if (lista.indexOf(datos_cancion) == -1) {
      emit(RecordingSucces(recordContent: datos_cancion, favFlag: false));
    } else {
      emit(RecordingSucces(recordContent: datos_cancion, favFlag: true));
    }
  } else {
    emit(RecordingError(error: 'upsi'));
  }
}

FutureOr<void> _clickFunction(clickOnSuccesEvent event, emit) {
  switch (event.funcion_boton) {
    case 'fav':
      lista.add(event.datos_cancion);
      print('song added to list');

      break;
    case 'spotify':
      break;
    case 'deezer':
      break;
    case 'apple':
      break;
  }
}

FutureOr<void> _showFav(verFavoritosEvent, emit) {
  emit(favoritos());
}
