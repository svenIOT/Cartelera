import 'package:flutter/material.dart';

import 'package:cartelera/src/models/film_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  final List<Film> films;

  CardSwiper({@required this.films});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: _screenSize.height * 0.01),
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context, int index) {
            films[index].uniqueId = '${films[index].id}-card';

            return Hero(
              tag: films[index].uniqueId,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'details',
                        arguments: films[index]),
                    child: FadeInImage(
                        image: NetworkImage(films[index].getPosterPath()),
                        placeholder: AssetImage('assets/img/loading.gif'),
                        fit: BoxFit.cover),
                  )),
            );
          },
          itemCount: films.length),
    );
  }
}
