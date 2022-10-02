part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StartRecordEvent extends HomeEvent {}

class clickOnSuccesEvent extends HomeEvent {
  final String funcion_boton;
  final DatosCancion datos_cancion;
  final bool favFlag;
  clickOnSuccesEvent(
      {required this.funcion_boton,
      required this.datos_cancion,
      required this.favFlag});
  @override
  List<Object> get props => [funcion_boton, datos_cancion, favFlag];
}

class verFavoritosEvent extends HomeEvent {}
