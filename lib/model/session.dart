import 'dart:io';
import 'dart:ui';

class Session {
  final File picture;
  final Image image;
  final String name;

  Session({this.picture, this.name, this.image});

  Session copyWith({File picture, Image image, String name}) {
    return Session(
        picture: picture ?? this.picture,
        image: image ?? this.image,
        name: name ?? this.name);
  }
}
