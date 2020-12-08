import 'package:flutter/material.dart';

import 'package:cartelera/src/widgets/card_swiper_widget.dart';
import 'package:cartelera/src/providers/films_provider.dart';
import 'package:cartelera/src/widgets/film_horizontal.dart';
import 'package:cartelera/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  final filmsProvider = new FilmsProvider();
  @override
  Widget build(BuildContext context) {
    filmsProvider.getPopularFilms();

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  showSearch(context: context, delegate: DataSearch()))
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swipeCards(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swipeCards() {
    return FutureBuilder(
        future: filmsProvider.getNowPlayingFilms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) =>
            (snapshot.hasData)
                ? CardSwiper(
                    films: snapshot.data,
                  )
                : Container(
                    height: 450.0,
                    child: Center(child: CircularProgressIndicator())));
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5.0),
          StreamBuilder(
              stream: filmsProvider.popularsStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  (snapshot.hasData)
                      ? FilmHorizontal(
                          films: snapshot.data,
                          nextPage: filmsProvider.getPopularFilms)
                      : Container(
                          child: Center(child: CircularProgressIndicator()))),
        ],
      ),
    );
  }
}
