class Song {
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;
  final List<String> hashtags;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
    this.hashtags = const [],
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songName: json['songName'],
      artistName: json['artistName'],
      albumArtImagePath: json['albumArtImagePath'],
      audioPath: json['audioPath'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
    );
  }
}
