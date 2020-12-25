import 'package:flutter/material.dart';

import 'package:cartelera/src/models/film_model.dart';
import 'package:cartelera/src/models/actor_model.dart';
import 'package:cartelera/src/providers/films_provider.dart';

class FilmDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Film film = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _createAppbar(film),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10.0),
          _bannerTitle(context, film),
          _description(film),
          _genres(film),
          _createActors(film)
        ]))
      ],
    ));
  }

  Widget _createAppbar(Film film) => SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigoAccent,
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(film.title,
              style: TextStyle(color: Colors.white, fontSize: 16.0)),
          background: FadeInImage(
              image: NetworkImage(film.getBackgroundImg()),
              placeholder: AssetImage('assets/img/loading.gif'),
              fadeInDuration: Duration(milliseconds: 500),
              fit: BoxFit.cover),
        ),
      );

  Widget _bannerTitle(BuildContext context, Film film) => Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(children: <Widget>[
          Hero(
            tag: film.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(film.getPosterPath()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    film.releaseDate.substring(0, 4),
                    style: Theme.of(context).textTheme.headline4,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      film.title,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      film.originalTitle,
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Icon(Icons.star_border),
                Text(
                  film.voteAverage.toString(),
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ])
            ],
          ))
        ]),
      );

  Widget _description(Film film) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Text(film.overview, textAlign: TextAlign.justify));

  Widget _createActors(Film film) {
    final filmProvider = new FilmsProvider();

    return FutureBuilder(
        future: filmProvider.getActors(film.id.toString()),
        builder: (context, AsyncSnapshot<List> snapshot) => snapshot.hasData
            ? _createActorsPageView(snapshot.data)
            : Center(child: CircularProgressIndicator()));
  }

  Widget _createActorsPageView(List<Actor> actors) => SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(initialPage: 1, viewportFraction: 0.3),
          itemCount: actors.length,
          itemBuilder: (context, index) => _actorCard(actors[index])));

  Widget _actorCard(Actor actor) => Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: NetworkImage(actor.getActorImg()),
                    height: 150.0,
                    fit: BoxFit.cover)),
            Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );

  Widget _genres(Film film) {
    final filmProvider = new FilmsProvider();
    return FutureBuilder(
        future: filmProvider.getGenres(film.genreIds),
        builder: (context, AsyncSnapshot<List> snapshot) {
          List<String> genres = new List<String>();
          if (snapshot.hasData) {
            snapshot.data.forEach((element) {
              genres.add(element.name);
            });
            return _genresList(genres);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _genresList(List<String> genres) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Géneros: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(genres.toString()),
            ],
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ));
}
