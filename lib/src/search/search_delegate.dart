import 'package:flutter/material.dart';

import 'package:cartelera/src/models/film_model.dart';
import 'package:cartelera/src/providers/films_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';

  final filmsProvider = new FilmsProvider();

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              query = '';
            })
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      });

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder(
        future: filmsProvider.searchFilm(query),
        builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) =>
            snapshot.hasData
                ? ListView(
                    children: snapshot.data
                        .map((film) => ListTile(
                              leading: FadeInImage(
                                image: NetworkImage(film.getPosterPath()),
                                placeholder:
                                    AssetImage('assets/img/loading.gif'),
                                width: 50.0,
                                fit: BoxFit.contain,
                              ),
                              title: Text(film.title),
                              subtitle: Text(film.originalTitle),
                              onTap: () {
                                close(context, null);
                                film.uniqueId = '';
                                Navigator.pushNamed(context, 'details',
                                    arguments: film);
                              },
                            ))
                        .toList())
                : Center(child: CircularProgressIndicator()));
  }
}
