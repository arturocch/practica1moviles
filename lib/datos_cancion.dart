import 'package:flutter/material.dart';

@immutable
class DatosCancion {
  final String artista;
  final String titulo;
  final String album;
  final String fecha;
  final String link;
  final String appleLink;
  final String spotifyLink;
  final String deezerLink;
  final String imagen;

  const DatosCancion({
    required this.artista,
    required this.titulo,
    required this.album,
    required this.fecha,
    required this.link,
    required this.appleLink,
    required this.spotifyLink,
    required this.deezerLink,
    required this.imagen,
  });

  DatosCancion.fromJson(json)
      : this(
          artista: json["result"]!["artist"] as String,
          titulo: json["result"]!["title"] as String,
          album: json["result"]!["album"] as String,
          fecha: json["result"]!["release_date"] as String,
          link: json["result"]!["song_link"] as String,
          appleLink: json["result"]!["apple_music"]["url"] as String,
          spotifyLink:
              json["result"]!["spotify"]["external_urls"]["spotify"] as String,
          deezerLink: json["result"]!["deezer"]["link"] as String,
          imagen:
              json["result"]!["spotify"]["album"]["images"][0]["url"] as String,
        );
}
