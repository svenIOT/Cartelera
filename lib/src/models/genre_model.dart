class Genres {
  List<Genre> genres = new List();

  Genres.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final genre = Genre.fromJsonMap(item);
      genres.add(genre);
    });
  }
}

class Genre {
  int id;
  String name;

  Genre({this.id, this.name});

  Genre.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
