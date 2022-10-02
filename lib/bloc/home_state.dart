part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeRecording extends HomeState {}

class favoritos extends HomeState {
  final List listaParaPantalla = lista;
  @override
  List<Object> get props => [listaParaPantalla];
}

class RecordingSucces extends HomeState {
  final DatosCancion recordContent;
  final bool favFlag;

  RecordingSucces({required this.recordContent, required this.favFlag});
  @override
  List<Object> get props => [recordContent, favFlag];
}

class RecordingError extends HomeState {
  final String error;

  RecordingError({required this.error});
  @override
  List<Object> get props => [error];
}
