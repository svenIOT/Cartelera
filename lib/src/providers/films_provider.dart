import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cartelera/src/models/actor_model.dart';
import 'package:cartelera/src/models/film_model.dart';

class FilmsProvider {
  String _apikey = '3e593ea4dfd7378d8d9fc28d6f1dff85';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPages = 0;
  bool _loading = false;

  List<Film> _populars = new List();

  final _popularsStreamController = StreamController<List<Film>>.broadcast();

  Function(List<Film>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Film>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController.close();
  }

  Future<List<Film>> getNowPlayingFilms() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _responseProcess(url);
  }

  Future<List<Film>> getPopularFilms() async {
    if (_loading) return [];

    _loading = true;
    ++_popularPages;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularPages.toString()
    });

    final resp = await _responseProcess(url);

    _populars.addAll(resp);
    popularsSink(_populars);
    _loading = false;

    return resp;
  }

  Future<List<Film>> _responseProcess(Uri url) async {
    final response = await http.get(url);

    final decodedData = json.decode(response.body);

    final films = new Films.fromJsonList(decodedData['results']);

    return films.items;
  }

  Future<List<Actor>> getActors(String filmId) async {
    final url = Uri.https(_url, '3/movie/$filmId/credits',
        {'api_key': _apikey, 'language': _language});

    final response = await http.get(url);

    final decodedData = json.decode(response.body);

    final cast = new Actors.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Film>> searchFilm(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _responseProcess(url);
  }
}
