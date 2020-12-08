import 'package:flutter/material.dart';

import 'package:cartelera/src/models/film_model.dart';

class FilmHorizontal extends StatelessWidget {
  final List<Film> films;
  final Function nextPage;

  FilmHorizontal({@required this.films, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 250) nextPage();
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: films.length,
        itemBuilder: (context, index) => _card(context, films[index]),
      ),
    );
  }

  Widget _card(BuildContext context, Film film) {
    film.uniqueId = '${film.id}-banner';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: film.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(film.getPosterPath()),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(film.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption)
        ],
      ),
    );

    return GestureDetector(
        child: card,
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: film);
        });
  }
}
